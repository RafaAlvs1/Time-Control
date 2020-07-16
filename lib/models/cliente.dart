import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String _path_clientes = 'clientes';

class ClienteArguments {
  final Cliente cliente;

  ClienteArguments(this.cliente);
}

class Cliente {
  String id;
  String nome;
  String logoUrl;
  String uid;
  Timestamp criadoEm;

  static CollectionReference get clientes => Firestore.instance.collection(_path_clientes);
  StorageReference get storageRef {
    if (id != null) {
      return FirebaseStorage.instance.ref().child(_path_clientes).child(id).child('logo');
    } else {
      return null;
    }
  }

  static Stream<List<Cliente>> lista(String uid) {
    return clientes
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot event) => event.documents.map((DocumentSnapshot snapshot) => Cliente.fromDoc(snapshot)).toList())
    ;
  }

  Cliente({
    this.id,
    this.nome,
    this.logoUrl,
    this.criadoEm,
  });

  factory Cliente.fromDoc(DocumentSnapshot snapshot) {
    return Cliente(
      id: snapshot.documentID,
      nome: snapshot['nome'],
      logoUrl: snapshot['logoUrl'],
      criadoEm: snapshot['criadoEm'],
    );
  }

  factory Cliente.fromMap(Map<String, dynamic> snapshot) {
    if (snapshot == null) {
      return null;
    }
    return Cliente(
      id: snapshot['id'],
      nome: snapshot['nome'],
      logoUrl: snapshot['logoUrl'],
    );
  }

  Map<String, dynamic> toJSON([bool hasId = true]) {
    return {
      if(hasId && id != null) 'id': id,
      if(nome != null) 'nome': nome,
      if(logoUrl != null) 'logoUrl': logoUrl,
      if(uid != null) 'uid': uid,
      'criadoEm': criadoEm ?? FieldValue.serverTimestamp(),
    };
  }

  Future<String> save() async {
    if (id != null) {
      await clientes.document(id).updateData(toJSON(false));
      return id;
    } else {
      uid = (await FirebaseAuth.instance.currentUser()).uid;
      DocumentReference doc = await clientes.add(toJSON(false));
      id = doc.documentID;
      return doc.documentID;
    }
  }

  Future<void> delete() async {
    return clientes.document(id).delete();
  }

  @override
  String toString() {
    return 'Cliente{id: $id, nome: $nome, logoUrl: $logoUrl}';
  }
}