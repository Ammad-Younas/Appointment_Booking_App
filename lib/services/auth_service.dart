// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email and Password
  Future<Map<String, dynamic>> signUpWithEmailPassword({
    required String email,
    required String password,
    String role = 'patient', // Default role
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({'email': email, 'role': role, 'createdAt': FieldValue.serverTimestamp(), 'profileComplete': false});

      // Send Email Verification
      await userCredential.user!.sendEmailVerification();

      // Sign out immediately so they can't access the app until verified
      await _auth.signOut();

      return {'success': true, 'message': 'Account created successfully. Please verify your email.'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  // Sign In with Email and Password
  Future<Map<String, dynamic>> signInWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          // If not verified, sign out and throw error
          await _auth.signOut();
          return {'success': false, 'message': 'Please verify your email before logging in.'};
        }
        return {'success': true, 'message': 'Login successful', 'user': user};
      } else {
        return {'success': false, 'message': 'Login failed. User is null.'};
      }
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  // Send Password Reset Email with App Link settings
  Future<Map<String, dynamic>> sendPasswordResetEmail({required String email}) async {
    try {
      // Configure settings to open the app
      final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url: 'https://appointly-app.firebaseapp.com/__/auth/action?mode=resetPassword', // Your Firebase project hosting URL
        handleCodeInApp: true,
        androidPackageName: 'com.example.appointment_booking_app', // Replace with your actual package name found in AndroidManifest.xml
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );

      await _auth.sendPasswordResetEmail(email: email, actionCodeSettings: actionCodeSettings);

      return {'success': true, 'message': 'Password reset email sent. Please check your inbox and click the link to reset your password in the app.'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  // Confirm Password Reset (using the code from the email link)
  Future<Map<String, dynamic>> confirmPasswordReset({required String code, required String newPassword}) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
      return {'success': true, 'message': 'Password reset successfully. Please login with your new password.'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  // Verify OTP Code (for phone verification or custom implementation)
  Future<Map<String, dynamic>> verifyOTP({required String verificationId, required String otp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);

      await _auth.signInWithCredential(credential);

      return {'success': true, 'message': 'OTP verified successfully'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'Invalid OTP. Please try again.'};
    }
  }

  // Update Password (for logged-in users)
  Future<Map<String, dynamic>> updatePassword({required String newPassword}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      await user.updatePassword(newPassword);

      return {'success': true, 'message': 'Password updated successfully'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Delete Account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user from Firebase Auth
      await user.delete();

      return {'success': true, 'message': 'Account deleted successfully'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login instead.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'requires-recent-login':
        return 'Please login again to perform this action.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Re-authenticate user (needed for sensitive operations)
  Future<Map<String, dynamic>> reAuthenticateUser({required String email, required String password}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      await user.reauthenticateWithCredential(credential);

      return {'success': true, 'message': 'Re-authentication successful'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }
}
