import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; // Default tab index
  List<CartItemData> cartItems = []; // List to store cart items

  static List<Widget> _widgetOptions = <Widget>[
    ServicesCatalogScreen(),
    // CartScreen() will be dynamically created
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(String title, int price, String duration) {
    setState(() {
      cartItems.add(CartItemData(
        title: title,
        price: price,
        count: 1,
        duration: duration,
      ));
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void incrementCount(int index) {
    setState(() {
      cartItems[index].count++;
    });
  }

  void decrementCount(int index) {
    setState(() {
      if (cartItems[index].count > 1) {
        cartItems[index].count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1
          ? CartScreen(
        cartItems: cartItems,
        onRemove: removeFromCart,
        onIncrement: incrementCount,
        onDecrement: decrementCount,
      )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ServicesCatalogScreen extends StatefulWidget {
  @override
  _ServicesCatalogScreenState createState() => _ServicesCatalogScreenState();
}

class _ServicesCatalogScreenState extends State<ServicesCatalogScreen> {
  void _addToCart(String title, int price, String duration) {
    final bottomNavBarState = context.findAncestorStateOfType<_BottomNavBarState>();
    bottomNavBarState?._addToCart(title, price, duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список услуг'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ServiceItem(
            title: 'ПЦР-тест на определение РНК коронавируса стандартный',
            price: 1800,
            duration: '2 дня',
            onAdd: () => _addToCart('ПЦР-тест на определение РНК коронавируса стандартный', 1800, '2 дня'),
          ),
          ServiceItem(
            title: 'Клинический анализ крови с лейкоцитарной формулой',
            price: 690,
            duration: '1 день',
            onAdd: () => _addToCart('Клинический анализ крови с лейкоцитарной формулой', 690, '1 день'),
          ),
          ServiceItem(
            title: 'Биохимический анализ крови, базовый',
            price: 2440,
            duration: '1 день',
            onAdd: () => _addToCart('Биохимический анализ крови, базовый', 2440, '1 день'),
          ),
        ],
      ),
    );
  }
}


class ServiceItem extends StatelessWidget {
  final String title;
  final int price;
  final String duration;
  final VoidCallback onAdd;

  const ServiceItem({
    Key? key,
    required this.title,
    required this.price,
    required this.duration,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Текст с названием и информацией
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Текст переносится на новую строку при необходимости
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                    softWrap: true, // Разрешаем перенос текста
                    overflow: TextOverflow.visible, // Отключаем обрезку
                  ),
                  Text('$price ₽', style: TextStyle(fontSize: 16)),
                  Text(duration, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            // Кнопка "Добавить"
            ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Эдуард', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text('+7 900 800-55-33', style: TextStyle(height: 3, color: Colors.grey)),
                  Text('email@gmail.com', style: TextStyle(height: 3, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Image.asset('photos/заказ.png', width: 30),
              title: Text('Мои заказы', style: TextStyle(height: 3)),
            ),
            ListTile(
              leading: Image.asset('photos/папка.png', width: 30),
              title: Text('Медицинские карты', style: TextStyle(height: 3)),
            ),
            ListTile(
              leading: Image.asset('photos/дом.png', width: 30),
              title: Text('Мои адреса', style: TextStyle(height: 3)),
            ),
            ListTile(
              leading: Image.asset('photos/настройка.png', width: 30),
              title: Text('Настройки', style: TextStyle(height: 3)),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Ответы на вопросы', style: TextStyle(fontSize: 18, height: 3, color: Colors.grey)),
                Text('Политика конфиденциальности', style: TextStyle(fontSize: 18, height: 3, color: Colors.grey)),
                Text('Пользовательское соглашение', style: TextStyle(fontSize: 18, height: 3, color: Colors.grey)),
                SizedBox(height: 40),
                TextButton(
                  onPressed: () {},
                  child: Text('Выход', style: TextStyle(fontSize: 18, color: Colors.red)),
                ),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<CartItemData> cartItems;
  final Function(int) onRemove;
  final Function(int) onIncrement;
  final Function(int) onDecrement;

  CartScreen({
    required this.cartItems,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });


  int _calculateTotalPrice() {
    int total = 0;
    for (var item in cartItems) {
      total += item.price * item.count;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return CartItem(
                    title: cartItems[index].title,
                    price: cartItems[index].price,
                    duration: cartItems[index].duration,
                    patientCount: cartItems[index].count,
                    onRemove: () => onRemove(index),
                    onIncrement: () => onIncrement(index),
                    onDecrement: () => onDecrement(index),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сумма:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_calculateTotalPrice()} ₽',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {


                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Перейти к оформлению',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CartItem extends StatelessWidget {
  final String title;
  final int price;
  final String duration;
  final int patientCount;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  CartItem({
    required this.title,
    required this.price,
    required this.duration,
    required this.patientCount,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Левый верхний угол - текст
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18),
                        softWrap: true, // Разрешаем перенос текста
                        overflow: TextOverflow.visible, // Отключаем обрезку
                      ),
                    ],
                  ),
                ),
                // Правый верхний угол - кнопка удаления
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Левый нижний угол - цена
                Text(
                  '$price ₽',
                  style: TextStyle(fontSize: 16),
                ),
                // Правый нижний угол - счётчик пациентов и кнопки + и -
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: onDecrement,
                    ),
                    Text('$patientCount', style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemData {
  final String title;
  final int price;
  int count;
  final String duration;

  CartItemData({
    required this.title,
    required this.price,
    required this.count,
    required this.duration,
  });
}
