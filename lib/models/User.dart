import 'package:uuid/uuid.dart';
import 'NFT.dart';

class User {
  late String _id;
  late String email;
  List<NFT> portfolioCollection = <NFT>[];

  User(String email) {
    this._id = _validateId();
    this.email = email;
  }

  String get id => _id;

  String _validateId() {
    this._id = Uuid().v1();
    return _idExistsInDB(this._id) ? Uuid().v1() : this._id;
  }

  bool _idExistsInDB(String id) {
    // expression to check existing id in DB
    bool db = false;
    // or id == db if db is String
    return false;
  }

  @override
  String toString() => 'User: $id - $email';

}
