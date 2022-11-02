import 'package:client/services/room_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

const appId = "zZc3kXA5JWnzVD4I12I5vTz8hdf9rDcRyEv9iYkg";
const appUrl = "http://localhost:1337/parse";
const keyParseClientKey = "123";
const keyLiveQueryUrl = "ws://localhost:1337/parse";

class AuthService {
  ParseUser? user;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "774146404712-r9jilopjq1jm35fe2k77lh115dcpmjim.apps.googleusercontent.com",
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  Future<void> init() async {
    await Parse().initialize(appId, appUrl,
        clientKey: keyParseClientKey,
        debug: true,
        liveQueryUrl: keyLiveQueryUrl,
        autoSendSessionId: true,
      registeredSubClassMap: <String, ParseObjectConstructor>{
        Room.keyTableName: () => Room(),
      },
    );
    await getCurrentUser();
  }

  Future<ParseUser?> getCurrentUser() async {
    user = await ParseUser.currentUser();
    return user;
  }

  Future<void> signInGoogle() async {
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      var result = await ParseUser.loginWith(
          'google',
          google(authentication.accessToken!, _googleSignIn.currentUser!.id,
              authentication.idToken!));
      await getCurrentUser();
    }
  }

  void logout() {
    user?.logout();
    _googleSignIn.signOut();
    user = null;
  }
}
