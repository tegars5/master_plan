# Tugas Praktikum 1: Dasar State dengan Model-View

## 1. Dokumentasi Praktikum dalam GIF

![GIF Praktikum](/assets/images/praktikum1.gif)

Aplikasi ini memungkinkan pengguna untuk menambahkan, mengedit, dan menandai tugas sebagai selesai dalam daftar perencanaan.

## 2. Penjelasan Langkah 4

Pada langkah 4, kita menginisialisasi `ScrollController` dan menambahkan listener untuk menghilangkan fokus dari input saat pengguna melakukan scroll.

```dart
scrollController = ScrollController()..addListener(() {
  FocusScope.of(context).unfocus();
});
```

**Alasan dilakukan demikian:**

- Saat pengguna mengetik dalam `TextFormField`, keyboard muncul.
- Jika pengguna ingin scroll tanpa menutup keyboard, tampilan bisa menjadi tidak rapi.
- Oleh karena itu, fokus dihilangkan secara otomatis saat scroll untuk memastikan UI tetap nyaman.

## 3. Pentingnya Variabel `plan` pada Langkah 6

Variabel `plan` digunakan untuk menyimpan daftar tugas pengguna.

```dart
Plan plan = Plan(name: 'Rencana Saya', tasks: []);
```

**Alasan mengapa diperlukan:**

- `plan` menyimpan daftar tugas yang ditampilkan dalam `ListView.builder`.
- Tanpa `plan`, aplikasi tidak bisa menyimpan atau memperbarui daftar tugas.

**Mengapa tidak menggunakan `const`?**

- `const` hanya digunakan untuk objek yang tidak berubah.
- Karena `plan` akan terus diperbarui (misalnya, saat menambahkan tugas), maka `const` tidak diperlukan.

## 4. Capture Hasil Langkah 9 dalam GIF

![Praktikum ke 2](/assets/images/prak2.gif)

**Penjelasan:**

- Aplikasi menampilkan daftar tugas menggunakan `ListView.builder`.
- Pengguna bisa menambahkan, mengedit, dan menandai tugas sebagai selesai.
- Checkbox menunjukkan apakah tugas sudah selesai atau belum.

Kode yang digunakan untuk menampilkan daftar tugas:

```dart
Widget _buildList() {
  return ListView.builder(
    controller: scrollController,
    itemCount: plan.tasks.length,
    itemBuilder: (context, index) => _buildTaskTile(plan.tasks[index], index),
  );
}
```

## 5. Kegunaan `initState()` dan `dispose()` dalam Lifecycle State

### `initState()` (Langkah 11)

Digunakan untuk menginisialisasi `ScrollController`.

```dart
@override
void initState() {
  super.initState();
  scrollController = ScrollController()..addListener(() {
    FocusScope.of(context).unfocus();
  });
}
```

**Fungsinya:**

- Menyiapkan `scrollController` agar bisa menangani event scroll.
- Menutup keyboard saat pengguna melakukan scroll.

### `dispose()` (Langkah 13)

Digunakan untuk membersihkan `ScrollController` saat widget dihancurkan.

```dart
@override
void dispose() {
  scrollController.dispose();
  super.dispose();
}
```

**Fungsinya:**

- Menghindari **memory leak** dengan membuang `scrollController` dari memori saat widget dihancurkan.

---
