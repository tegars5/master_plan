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

# Praktikum 2: Mengelola Data Layer dengan InheritedWidget dan InheritedNotifier

## 1. Hasil Langkah 9 dalam GIF

(GIF hasil praktikum ditampilkan di sini)

## 2. Penjelasan InheritedWidget pada Langkah 1

Pada langkah 1, kita membuat `PlanProvider` yang menggunakan `InheritedNotifier<ValueNotifier<Plan>>`.

### Apa itu InheritedWidget?

- `InheritedWidget` adalah widget khusus yang digunakan untuk menyediakan data ke widget turunannya tanpa perlu meneruskannya secara eksplisit melalui constructor.
- Biasanya digunakan untuk state management global dalam aplikasi Flutter.

### Mengapa Menggunakan InheritedNotifier?

- `InheritedNotifier` adalah versi lebih efisien dari `InheritedWidget` karena hanya widget yang tergantung pada perubahan state yang akan di-rebuild.
- `ValueNotifier<Plan>` digunakan agar ketika ada perubahan pada `Plan`, hanya widget yang membutuhkan data `Plan` yang akan diperbarui, bukan seluruh tree widget.

## 3. Penjelasan Method di Langkah 3

Pada langkah 3, kita menambahkan dua method dalam `Plan` model:

```dart
int get completedCount => tasks.where((task) => task.complete).length;

String get completenessMessage =>
  '$completedCount out of \${tasks.length} tasks';
```

### Penjelasan:

- `completedCount`: Menghitung jumlah task yang sudah selesai (`complete == true`).
- `completenessMessage`: Menampilkan progress dalam bentuk teks, misalnya:

```csharp
3 out of 5 tasks
```

yang berarti ada 3 tugas selesai dari total 5 tugas yang ada.

### Mengapa Ini Diperlukan?

- Untuk memberikan feedback kepada user tentang progress task mereka.
- Mempermudah pembaruan UI ketika ada perubahan pada jumlah task yang selesai.

## 4. Kesimpulan

- Menggunakan `InheritedNotifier` memungkinkan kita mengelola state secara lebih efisien.
- Method `completedCount` dan `completenessMessage` berguna untuk menampilkan progress penyelesaian tugas.
- Menampilkan hasil langkah 9 dalam GIF menunjukkan bahwa aplikasi berhasil mengupdate progress task secara otomatis.
