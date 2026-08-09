import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartware/features/client/home/controllers/client_home_controller.dart';
import 'package:smartware/features/client/home/views/ads_carousel_view.dart';
import 'package:smartware/features/client/home/views/filtering_menu.dart';
import 'package:smartware/features/client/widgets/product_card.dart';
import 'package:smartware/features/client/widgets/horizontal_product_row.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/dynamic_filter_row.dart';


class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final media = MediaQuery.of(context).size;
    final controller = Get.find<ClientHomeController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
       body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          },
         child: SafeArea(
           child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: 12),
                  child:  Padding(
                    padding: EdgeInsets.only(top: media.height * 0.01),
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SmartWare",
                            style: const TextStyle(
                              fontFamily: 'Michroma',
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ).copyWith(color: colors.onSurface),
                          ),
                          Text(
                            "Welcome back, @userName!".trParams({
                              "userName": controller.userName,
                            }),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface.withOpacity(0.8),
                              fontSize: 17,
                            ),
                          ),
                          
                        ],
                      ),
                      Spacer(),
                      //Top Icons
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: colors.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.notifications_outlined),
                          color: colors.onSurface.withOpacity(0.8),
                          iconSize: 25,),
                      ),
                      SizedBox(width: media.width * 0.03),
                                    
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: colors.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.shopping_cart_outlined),
                          color: colors.onSurface.withOpacity(0.8),),
                      ),
                    ],
                  ),
                ),
              
           ),
           ),
           // pinned search bar 
           SliverAppBar(
                  pinned: true,
                  floating: false,
                  primary: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  // Use title spacing to match the outer horizontal padding
                  titleSpacing: media.width * 0.05, 
                  toolbarHeight: 60,
                  title: CustomTextField(
                   isSearch: true,
                   hint: "Search for products".tr,
                   prefixIcon: Icon(
                    Icons.search,
                    color: colors.onSurface.withOpacity(0.6),
                    size: 25,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      Get.bottomSheet(const FilteringMenu(),
                      isScrollControlled: true, // Crucial for DraggableScrollableSheet to expand properly
                      backgroundColor: Colors.transparent,);
                      
                    },
                    icon: Icon(Icons.filter_list_outlined),
                  ),
                  fillColor: colors.onSurface.withValues(alpha: 0.05),
                ),
           ),
           SliverToBoxAdapter(
            child: Padding(
              padding:
               EdgeInsets.symmetric(vertical: 14, horizontal: media.width * 0.03),
               child: SizedBox(
                height: media.height * 0.2,
                child: AutoMovingAdsCarousel()),
            ),
            ),
            //=========== The filtering chips =========
              SliverToBoxAdapter(
                child: DynamicFilterRow(),
              ),
            //========= Most Selling ==========
            SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: HorizontalProductRow(
                title: "Top Selling".tr,
                onSeeAllPressed: () {},
              ),
            )
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: HorizontalProductRow(
                  title: "Special Sales".tr,
                  onSeeAllPressed: () {
                    // Handle view routing
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: HorizontalProductRow(
                title: "Buy It Again".tr,
                itemCount: 3, // Say they only have 3 items historically ordered
              ),
            ),
          ),
          // ... previous horizontal rows ...

//========= Section Header for All Products ==========
SliverToBoxAdapter(
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: 16),
    child: Text(
      "All Products".tr,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  ),
),

//========= Main Product Grid ==========
SliverPadding(
  padding: EdgeInsets.symmetric(horizontal: media.width * 0.03),
  sliver: SliverGrid.builder(
    itemCount: 10, // Replace with your controller list length later
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,          
      mainAxisSpacing: 16,       
      childAspectRatio: 0.67,     // Width-to-height ratio (Adjust based on card design)
    ),
    itemBuilder: (context, index) {
      return const ProductCard(); // Renders your standard client product card
    },
  ),
),

            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
           ],
           
            ),
         ),
       ),
      );
     
  }
}