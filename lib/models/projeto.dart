import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'cliente.dart';

const String _path_projetos = 'projetos';

class ProjetoArguments {
  final Projeto projeto;

  ProjetoArguments(this.projeto);
}

class Projeto {
  String id;
  String nome;
  String logoUrl;
  String uid;
  Timestamp criadoEm;
  Cliente cliente;

  static CollectionReference get projetos => Firestore.instance.collection(_path_projetos);
  StorageReference get storageRef {
    if (id != null) {
      return FirebaseStorage.instance.ref().child(_path_projetos).child(id).child('logo');
    } else {
      return null;
    }
  }

  static Stream<List<Projeto>> lista(String uid) {
    return projetos
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot event) => event.documents.map((DocumentSnapshot snapshot) => Projeto.fromDoc(snapshot)).toList())
    ;
  }

  Projeto({
    this.id,
    this.nome,
    this.logoUrl,
    this.criadoEm,
    this.cliente,
  });

  factory Projeto.fromDoc(DocumentSnapshot snapshot) {
    return Projeto(
      id: snapshot.documentID,
      nome: snapshot['nome'],
      logoUrl: snapshot['logoUrl'],
      criadoEm: snapshot['criadoEm'],
      cliente: Cliente.fromMap(snapshot['cliente']),
    );
  }

  factory Projeto.fromMap(Map<String, dynamic> snapshot) {
    if (snapshot == null) {
      return null;
    }
    return Projeto(
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
      if(cliente != null) 'cliente': cliente.toJSON(),
      'criadoEm': criadoEm ?? FieldValue.serverTimestamp(),
    };
  }

  Future<String> save() async {
    if (cliente == null) {
      throw Exception('Projeto sem cliente');
    }

    if (id != null) {
      await projetos.document(id).updateData(toJSON(false));
      return id;
    } else {
      uid = (await FirebaseAuth.instance.currentUser()).uid;

      final batch = Firestore.instance.batch();

      DocumentReference document = projetos.document();

      batch.setData(document, toJSON(false));
      batch.updateData(
        Cliente.clientes.document(cliente.id),
        {'projetos.${document.documentID}': true,},
      );

      await batch.commit();

      id = document.documentID;
      return document.documentID;
    }
  }

  Future<void> delete() async {
    final batch = Firestore.instance.batch();
    batch.delete(projetos.document(id));
    if (cliente != null) {
      batch.updateData(
        Cliente.clientes.document(cliente.id),
        {'projetos.${id}': FieldValue.delete(),},
      );
    }
    return batch.commit();
  }

  @override
  String toString() {
    return 'Projeto{id: $id, nome: $nome, logoUrl: $logoUrl}';
  }
}