import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  Company company = Company(
    company: "Apple",
    location: "San Francisco",
    employees: [
      Employee(
        name: "Bilol",
        age: 16,
        position: "Developer",
        skills: ["dart","flutter"],
      ),
      Employee(
        name: "Hasan",
        age: 25,
        position: "Developer",
        skills: ["dart","flutter"],
      ),
    ],
    products: [
      Product(name: "Project 1", price: 2002.99, inStock: true),
      Product(name: "Project 2", price: 42000.99, inStock: false),
    ],
  );

  void _editCompanyInfo() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditCompanyScreen(
        company: company,
        onSave: (updatedCompany) {
          setState(() {
            company = updatedCompany;
          });
        },
      ),
    ));
  }

  void _addNewEmployee() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditEmployeeScreen(
        onSave: (newEmployee) {
          setState(() {
            company.employees.add(newEmployee);
          });
        },
      ),
    ));
  }

  void _addNewProduct() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditProductScreen(
        onSave: (newProduct) {
          setState(() {
            company.products.add(newProduct);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editCompanyInfo,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CompanyCard(company: company),
            const SizedBox(height: 20),
            const Text('Employees',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: company.employees.length,
                itemBuilder: (context, index) {
                  return EmployeeCard(employee: company.employees[index]);
                },
              ),
            ),
            const Text('Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: company.products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: company.products[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addNewEmployee,
            tooltip: 'Add Employee',
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _addNewProduct,
            tooltip: 'Add Product',
            child: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}

class EditCompanyScreen extends StatefulWidget {
  final Company company;
  final ValueChanged<Company> onSave;

  const EditCompanyScreen(
      {super.key, required this.company, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _EditCompanyScreenState createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String companyName;
  late String location;

  @override
  void initState() {
    super.initState();
    companyName = widget.company.company;
    location = widget.company.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: companyName,
                decoration: const InputDecoration(labelText: 'Company Name'),
                onSaved: (value) {
                  companyName = value!;
                },
              ),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (value) {
                  location = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  widget.onSave(Company(
                    company: companyName,
                    location: location,
                    employees: widget.company.employees,
                    products: widget.company.products,
                  ));
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditEmployeeScreen extends StatefulWidget {
  final ValueChanged<Employee> onSave;

  const EditEmployeeScreen({super.key, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 0;
  String position = '';
  List<String> skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Position'),
                onSaved: (value) {
                  position = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Skills (comma separated)'),
                onSaved: (value) {
                  skills = value!.split(',').map((e) => e.trim()).toList();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  widget.onSave(Employee(
                      name: name,
                      age: age,
                      position: position,
                      skills: skills));
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProductScreen extends StatefulWidget {
  final ValueChanged<Product> onSave;

  const EditProductScreen({super.key, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0.0;
  bool inStock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = double.parse(value!);
                },
              ),
              SwitchListTile(
                title: const Text('In Stock'),
                value: inStock,
                onChanged: (value) {
                  setState(() {
                    inStock = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  widget.onSave(
                      Product(name: name, price: price, inStock: inStock));
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Company {
  String company;
  String location;
  List<Employee> employees;
  List<Product> products;

  Company({
    required this.company,
    required this.location,
    required this.employees,
    required this.products,
  });
}

class Employee {
  String name;
  int age;
  String position;
  List<String> skills;

  Employee({
    required this.name,
    required this.age,
    required this.position,
    required this.skills,
  });
}

class Product {
  String name;
  double price;
  bool inStock;

  Product({
    required this.name,
    required this.price,
    required this.inStock,
  });
}

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(company.company),
        subtitle: Text(company.location),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(employee.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${employee.age}'),
            Text('Position: ${employee.position}'),
            Text('Skills: ${employee.skills.join(', ')}'),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('Price: \$${product.price}'),
        trailing: Icon(product.inStock ? Icons.check : Icons.close,
            color: product.inStock ? Colors.green : Colors.red),
      ),
    );
  }
}
