import 'package:mobile/shared/db/tags/tags_table.dart';
import 'package:sqflite/sqflite.dart';

import '../tags/tag_fields.dart';
import '../todos/todo_fields.dart';
import '../todos/todos_table.dart';

Future<void> onCreate(Database db, int version) async {
  final batch = db.batch();

  for (var fn in _createDbFnList) {
    fn(batch);
  }

  await batch.commit();
}

typedef _CreateDbFn = void Function(Batch batch);

const List<_CreateDbFn> _createDbFnList = [
  _createTodos,
  _createTags,
];

void _createTodos(Batch batch) {
  batch.execute('''
    CREATE TABLE ${TodosTable.name} (
      ${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TodoFields.createdDate} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
      ${TodoFields.imagePath} TEXT NOT NULL,
      ${TodoFields.tagId} INTEGER,
      ${TodoFields.isCompleted} BOOLEAN DEFAULT 0 NOT NULL CHECK (${TodoFields.isCompleted} IN (0, 1)),
      FOREIGN KEY (${TodoFields.tagId}) REFERENCES ${TagsTable.name} (${TagFields.id})
    );
  ''');
}

void _createTags(Batch batch) {
  batch.execute('''
    CREATE TABLE ${TagsTable.name} (
      ${TagFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TagFields.createdDate} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
      ${TagFields.name} TEXT NOT NULL
    );
  ''');
}
