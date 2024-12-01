import 'package:choi_pos/models/inventory_item.dart';
import 'package:choi_pos/models/promo_code.dart';
import 'package:choi_pos/services/cart_validation.dart';
import 'package:choi_pos/services/get_inventory.dart';
import 'package:choi_pos/services/shop_cart.dart';
import 'package:choi_pos/widgets/cart_widget.dart';
import 'package:choi_pos/widgets/inventory_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  
  final List<InventoryItem> inventory = InventoryService().inventory;

  final List<CartItem> cart = [];

  String searchQuery = "";
  String selectedCategory = "Todas";

  String selectedPaymentMethod = 'Efectivo';
  String onSelectedPaymentMethod = 'Efectivo';
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();
  PromoCode? appliedPromoCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void addToCart(InventoryItem product) {
    if (!CartValidations.isProductAvailable(product)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Este producto no tiene cantidad disponible')),
      );
      return;
    }

    setState(() {
      cart.add(CartItem(name: 'testing', price: 123, quantity: 1));
    });
  }

  void updatePaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void updateSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  double calculateTotal() {
    double total =
        cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
    if (appliedPromoCode != null) {
      total = PromoCode.applyPromoCode(appliedPromoCode!, total);
    }
    return total;
  }

  void applyPromoCode() {
    final String code = promoCodeController.text.trim();
    // Simulación de códigos de promoción disponibles
    final promoCodes = [
      PromoCode(code: "PROMO10", type: "porcentaje", value: 10, isActive: true),
      PromoCode(
          code: "DISCOUNT50",
          type: "fijo",
          value: 50,
          isActive: false), // Código inactivo
    ];

    // Buscar el código de promoción
    final promoCode = promoCodes.where((p) => p.code == code).isNotEmpty
        ? promoCodes.firstWhere((p) => p.code == code)
        : null;

    // Validar si no se encontró el código o si está inactivo
    if (promoCode == null || !promoCode.isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("El código de promoción no es válido o está inactivo.")),
      );
      return;
    }

    // Aplicar la promoción
    setState(() {
      appliedPromoCode = promoCode; // Guardar el código aplicado
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Código aplicado: ${promoCode.code}")),
    );
  }

  void confirmPurchase() {
    if (_formKey.currentState?.validate() ?? true) {
      if (cart.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El carrito está vacío")),
        );
        return;
      }

      if (selectedPaymentMethod != 'Efectivo' &&
          CartValidations.isReferenceValid(
              referenceController.text, selectedPaymentMethod)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debe ingresar una referencia válida.")),
        );
        return;
      }

      // Aquí iría la lógica de compra y actualización del backend
      setState(() {
        cart.clear();
        appliedPromoCode = null;
        promoCodeController.clear();
        referenceController.clear();
        selectedPaymentMethod = 'Efectivo';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, completa los campos correctamente.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text('Cajero'),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Image(
                  image: AssetImage('assets/choi-image.png'),
                  height: 30,
                ),
              ),
            ],
          ),
          leading: IconButton(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: InventoryWidget(
                  inventory: inventory,
                  searchQuery: searchQuery,
                  selectedCategory: selectedCategory,
                  onAddToCart: addToCart,
                  onSearchQueryChanged: updateSearchQuery,
                  onCategoryChanged: updateSelectedCategory,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CartWidget(
                  calculateTotal: calculateTotal,
                  onPaymentMethodChanged: updatePaymentMethod,
                  cart: cart,
                  selectedPaymentMethod: selectedPaymentMethod,
                  applyPromoCode: applyPromoCode,
                  confirmPurchase: confirmPurchase,
                  promoCodeController: appliedPromoCode,
                  referenceController: referenceController,
                ),
              ),
            ],
          ),
        ));
  }
}
