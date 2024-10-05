import 'package:flutter/material.dart';
import 'package:pr5_corpsis/components/item_note.dart';
import 'package:pr5_corpsis/components/note_card.dart';
import 'package:pr5_corpsis/models/note.dart';
import 'create_note_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Note> notes = [];
  List<Note> favorites = [];

  @override
  void initState() {
    super.initState();
    notes = [
      Note(
        id: 1,
        title: 'Футболка Hollyhood',
        description: 'Стильная футболка с логотипом Hollyhood',
        photo_id: 'https://sun9-8.userapi.com/impg/epg9DL3Dt9WXzAm7Q6M6ntg5Yc0Jtm6SnIRsHg/yEpl4vkXAvA.jpg?size=800x800&quality=96&sign=b4607e0218b7cbb8bd6b5f450ba89047&type=album',
        price: 1790,
      ),
      Note(
        id: 2,
        title: 'Худи Hollyhood',
        description: 'Удобное худи для повседневной носки',
        photo_id: 'https://sun9-29.userapi.com/impg/4OjgXB5Vyx8rEtywEoWg3L7XJQQUFefNC8WllQ/UJ5VCsO4qyE.jpg?size=800x800&quality=96&sign=0b71454f0282085cf6d50250e3b1f279&type=album',
        price: 4790,
      ),
    ];
  }

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _openNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemNote(note: note, onDelete: _deleteNote),
      ),
    );
  }

  void _deleteNote(int id) {
    setState(() {
      notes.removeWhere((note) => note.id == id);
    });
  }

  void _toggleFavorite(Note note) {
    setState(() {
      if (favorites.contains(note)) {
        favorites.remove(note);
        note.isFavorite = false; // Обновляем статус заметки
      } else {
        favorites.add(note);
        note.isFavorite = true; // Обновляем статус заметки
      }
    });
  }

  void _removeFromFavorites(Note note) {
    setState(() {
      favorites.remove(note);
      note.isFavorite = false; // Обновляем статус заметки
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _getCurrentPage() {
      switch (_selectedIndex) {
        case 0:
          return _buildNoteList();
        case 1:
          return FavoritePage(
            favorites: favorites,
            onOpenNote: _openNote, // Передаем функцию для открытия
            onRemoveFromFavorites: _removeFromFavorites, // Передаем функцию для удаления
          );
        case 2:
          return ProfilePage();
        default:
          return _buildNoteList();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hollyhood'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateNotePage(onCreate: _addNote),
                ),
              );
            },
          ),
        ],
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранные',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildNoteList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () => _openNote(note),
          onToggleFavorite: () {
            _toggleFavorite(note);
          },
        );
      },
    );
  }
}
