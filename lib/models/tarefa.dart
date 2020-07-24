import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cliente.dart';
import 'projeto.dart';

const String _path_tarefas = 'tarefas';

class Tarefa {
  String id;
  String nome;
  String uid;
  Timestamp criadoEm;
  Timestamp finalizadoEm;
  Cliente cliente;
  Projeto projeto;

  static CollectionReference get _tarefas => Firestore.instance.collection(_path_tarefas);

  static Stream<List<Tarefa>> lista(String uid) {
    return _tarefas
        .where('uid', isEqualTo: uid)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((QuerySnapshot event) => event.documents.map((DocumentSnapshot snapshot) => Tarefa.fromDoc(snapshot)).toList())
    ;
  }

  Tarefa({
    this.id,
    this.nome,
    this.criadoEm,
    this.finalizadoEm,
    this.cliente,
    this.projeto,
  });

  factory Tarefa.fromDoc(DocumentSnapshot snapshot) {
    return Tarefa(
      id: snapshot.documentID,
      nome: snapshot['nome'],
      criadoEm: snapshot['criadoEm'],
      finalizadoEm: snapshot['finalizadoEm'],
      cliente: Cliente.fromMap(snapshot['cliente']),
      projeto: Projeto.fromMap(snapshot['projeto']),
    );
  }

  Map<String, dynamic> toJSON([bool hasId = true]) {
    return {
      if(hasId && id != null) 'id': id,
      if(nome != null) 'nome': nome,
      if(uid != null) 'uid': uid,
      if(cliente != null) 'cliente': cliente.toJSON(),
      if(projeto != null) 'projeto': projeto.toJSON(),
      'criadoEm': criadoEm ?? FieldValue.serverTimestamp(),
      if(finalizadoEm != null) 'finalizadoEm': finalizadoEm,
    };
  }

  Future<String> save() async {
//    if (cliente == null || projeto == null) {
//      throw Exception('Tarefa com informações incompletas');
//    }

    if (id != null) {
      await _tarefas.document(id).updateData(toJSON(false));
      return id;
    } else {
      uid = (await FirebaseAuth.instance.currentUser()).uid;

      final batch = Firestore.instance.batch();

      DocumentReference document = _tarefas.document();

      batch.setData(document, toJSON(false));
//      batch.updateData(
//        Cliente.clientes.document(cliente.id),
//        {'tarefas.${document.documentID}': true,},
//      );
//      batch.updateData(
//        Projeto.projetos.document(projeto.id),
//        {'tarefas.${document.documentID}': true,},
//      );
      await batch.commit();

      id = document.documentID;
      return document.documentID;
    }
  }

  Future<void> delete() async {
    final batch = Firestore.instance.batch();
    batch.delete(_tarefas.document(id));
    if (cliente != null) {
//      batch.updateData(
//        Cliente.clientes.document(cliente.id),
//        {'projetos.${id}': FieldValue.delete(),},
//      );
    }
    return batch.commit();
  }

  @override
  String toString() {
    return 'Tarefa{id: $id, nome: $nome, uid: $uid, criadoEm: $criadoEm, finalizadoEm: $finalizadoEm}';
  }
}