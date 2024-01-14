import 'package:flutter/material.dart';
import 'package:fyp2/FoodStallOwner/subCustomerOrder/acceptedOrder.dart';
import 'package:fyp2/FoodStallOwner/subCustomerOrder/completedOrder.dart';
import 'package:fyp2/FoodStallOwner/subCustomerOrder/rejectedOrder.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body:ListView(
        children: const [
          AcceptedOrder(),
          RejectedOrder(),
          CompeteOrder(),
        ],
      )
    );
  }
}

class AcceptedOrder extends StatelessWidget {
  const AcceptedOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const acceptedOrder()));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Ink.image(
                  image: const AssetImage('assets/images/OrderPrepare.jpg'),
                  height: 170,
                  fit: BoxFit.fill,
                ),
                const Text(
                 ' Accepted Order ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    backgroundColor: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RejectedOrder extends StatelessWidget {
  const RejectedOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const rejectedOrder()));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Ink.image(
                  image: const AssetImage('assets/images/reject.jpg'),
                  height: 170,
                  fit: BoxFit.fill,
                ),
                const Text(
                  ' Rejected Order ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    backgroundColor: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompeteOrder extends StatelessWidget {
  const CompeteOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const completedOrder()));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Ink.image(
                  image: const AssetImage('assets/images/serveFood.jpg'),
                  height: 170,
                  fit: BoxFit.fill,
                ),
                const Text(
                  ' Completed Order ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    backgroundColor: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



