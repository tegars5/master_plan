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

# Praktikum 3: State di Multiple Screens

## 1. Penjelasan Gambar Diagram

Gambar diagram menunjukkan bagaimana state dikelola dan berpindah antara dua layar dalam aplikasi Flutter.

### **Diagram Kiri** (Sebelum Navigasi)

- **MaterialApp** adalah root dari aplikasi Flutter.
- **PlanProvider** digunakan sebagai penyedia state untuk mengelola data yang akan digunakan di berbagai layar.
- **PlanCreatorScreen** adalah layar pertama tempat pengguna dapat membuat atau mengedit rencana.
- **Column** digunakan untuk menyusun layout secara vertikal.
- **TextField** digunakan untuk memasukkan input dari pengguna.
- **Expanded** digunakan agar ListView mengisi sisa ruang yang tersedia.
- **ListView** digunakan untuk menampilkan daftar item yang ada dalam sebuah rencana.

### **Diagram Kanan** (Setelah Navigasi dengan `Navigator.push`)

- Saat pengguna menavigasi ke layar **PlanScreen**, state dari **PlanProvider** tetap terjaga.
- **Scaffold** digunakan sebagai struktur dasar UI layar baru.
- **Column** masih digunakan untuk menyusun layout secara vertikal.
- **Expanded** tetap digunakan untuk memastikan ListView mengisi ruang yang tersisa.
- **SafeArea** digunakan untuk memastikan elemen UI tidak bertabrakan dengan area notifikasi atau sistem operasi.
- **ListView** tetap digunakan untuk menampilkan daftar item.
- **Text** digunakan untuk menampilkan informasi tambahan tentang rencana.

### **Hasil yang Dibuat**

1. Pengguna dapat menambahkan tugas baru ke dalam rencana.
2. State dari daftar tugas tetap terjaga meskipun pengguna berpindah dari **PlanCreatorScreen** ke **PlanScreen**.
3. Checkbox pada setiap tugas memungkinkan pengguna untuk menandai tugas sebagai selesai.
4. Jika pengguna mengetik sesuatu di **TextField**, nilai tersebut tetap tersimpan saat navigasi dilakukan.

![Hasil Praktikum 3](/assets/images/prak3.gif)
