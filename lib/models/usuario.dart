import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String _pathUsuarios = 'usuarios';

class Usuario {
  String id;
  String nome;
  String fotoUrl;
  String email;
  Timestamp lastUpdateAt;

  static CollectionReference get _usuarios => Firestore.instance.collection(_pathUsuarios);
  StorageReference get storageRef {
    if (id != null) {
      return FirebaseStorage.instance.ref().child(_pathUsuarios).child(id).child('perfil');
    } else {
      return null;
    }
  }

  static Stream<Usuario> minhaConta(String uid) {
    return _usuarios.document(uid).snapshots()
        .map((snapshot) => Usuario.fromDoc(snapshot));
  }

  Usuario({
    this.id,
    this.nome,
    this.fotoUrl,
    this.email,
  });

  factory Usuario.fromDoc(DocumentSnapshot snapshot) {
    if (snapshot == null || snapshot.data == null) {
      return null;
    }
    return Usuario(
      id: snapshot.documentID,
      nome: snapshot['nome'],
      fotoUrl: snapshot['fotoUrl'],
      email: snapshot['email'],
    );
  }

  Map<String, dynamic> toJSON({
    FieldValue lastUpdateAt
  }) {
    return {
      if(nome != null) 'nome': nome,
      if(fotoUrl != null) 'fotoUrl': fotoUrl,
      if(email != null) 'email': email,
      if(lastUpdateAt != null || this.lastUpdateAt != null) 'lastUpdateAt': lastUpdateAt ?? this.lastUpdateAt,
    };
  }

  Future<void> update() async {
    return _usuarios.document(id).updateData(toJSON(
      lastUpdateAt: FieldValue.serverTimestamp(),
    ));
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, fotoUrl: $fotoUrl, email: $email}';
  }
}