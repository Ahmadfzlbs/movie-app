import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/navigation/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller responsible for managing user authentication, session handling,
/// and fetching account details from the API. Uses GetX for state management.
class LoginController extends GetxController {
  /// Base URL for the API, loaded from environment variables.
  var api = dotenv.env['API_URL'] ?? '';

  /// API key for authenticating API requests, loaded from environment variables.
  var apiKey = dotenv.env['API_KEY'] ?? '';

  /// Controller for the username text field.
  TextEditingController usernameC = TextEditingController(text: 'Ahmadfzlbs');

  /// Controller for the password text field.
  TextEditingController pwC = TextEditingController(text: 'AhmadFauziLubis');

  /// Requests a new token for authentication.
  ///
  /// Returns the token as a [String], or `null` if the request fails.
  Future<String?> reqToken() async {
    var tokenUrl = Uri.https(api, dotenv.env['REQ_TOKEN'] ?? '');
    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
    };

    try {
      var tokenResponse = await http.get(tokenUrl, headers: headers);

      if (tokenResponse.statusCode == 200) {
        var tokenResponseJson = json.decode(tokenResponse.body);
        String? requestToken = tokenResponseJson['request_token'];
        return requestToken;
      } else {
        Get.snackbar("Error", "Failed to get request token");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return null;
    }
  }

  /// Handles the user login process.
  ///
  /// This includes requesting a token, validating the user's credentials,
  /// creating a session, and saving the account details. Displays appropriate
  /// messages on failure or success.
  Future<void> login() async {
    String? requestToken = await reqToken();

    if (requestToken == null) {
      Get.snackbar("Error", "Failed to retrieve request token");
      return;
    }

    var loginUrl = Uri.https(api, dotenv.env['URL_LOGIN'] ?? '');
    var loginHeaders = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'username': usernameC.text,
      'password': pwC.text,
      'request_token': requestToken,
    });

    try {
      var loginResponse =
          await http.post(loginUrl, headers: loginHeaders, body: body);

      if (loginResponse.statusCode == 200) {
        String? sessionId = await createSession(requestToken);

        if (sessionId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_id', sessionId);
          await prefs.setBool('isLoggedIn', true);

          await saveAccountDetails(sessionId);

          Get.snackbar("Success", "Login berhasil");
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.snackbar("Error", "Failed to create session");
        }
      } else {
        var errorResponse = json.decode(loginResponse.body);
        String errorMessage =
            errorResponse['status_message'] ?? 'Failed to login';
        Get.snackbar("Error", "Failed to login: $errorMessage");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Creates a new session using the provided [requestToken].
  ///
  /// Returns the session ID as a [String], or `null` if the session creation fails.
  Future<String?> createSession(String requestToken) async {
    var sessionUrl = Uri.https(api, dotenv.env['SESSION_NEW'] ?? '');
    var sessionHeaders = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'request_token': requestToken,
    });

    try {
      var sessionResponse =
          await http.post(sessionUrl, headers: sessionHeaders, body: body);

      if (sessionResponse.statusCode == 200) {
        var sessionResponseJson = json.decode(sessionResponse.body);
        return sessionResponseJson['session_id'];
      } else {
        Get.snackbar("Error", "Failed to create session");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return null;
    }
  }

  /// Fetches the account details using the provided [sessionId] and saves
  /// the account ID to shared preferences.
  Future<void> saveAccountDetails(String sessionId) async {
    var accountUrl = Uri.https(api, '/3/account', {
      'api_key': apiKey,
      'session_id': sessionId,
    });

    try {
      var accountResponse = await http.get(accountUrl);

      if (accountResponse.statusCode == 200) {
        var accountResponseJson = json.decode(accountResponse.body);
        int accountId = accountResponseJson['id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('account_id', accountId);

        print("Account ID: $accountId");
      } else {
        print("Response Body: ${accountResponse.body}");
        print(accountUrl);
        Get.snackbar("Error", "Failed to get account details");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Retrieves the account ID using the stored session ID from shared preferences.
  ///
  /// Returns the account ID as an [int], or `null` if it cannot be retrieved.
  Future<int?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');

    if (sessionId == null) {
      Get.snackbar("Error", "Session ID not found");
      return null;
    }

    var accountUrl = Uri.https(api, '/3/account', {
      'api_key': apiKey,
      'session_id': sessionId,
    });

    try {
      var accountResponse = await http.get(accountUrl);

      if (accountResponse.statusCode == 200) {
        var accountResponseJson = json.decode(accountResponse.body);
        int accountId = accountResponseJson['id'];
        print("Fetched Account ID: $accountId");
        return accountId;
      } else {
        Get.snackbar("Error", "Failed to get account details");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return null;
    }
  }
}
