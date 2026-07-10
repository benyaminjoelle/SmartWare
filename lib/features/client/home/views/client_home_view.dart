import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:storex/features/client/home/views/ads_carousel_view.dart';
import 'package:storex/features/client/home/views/filtering_menu.dart';
import 'package:storex/features/client/widgets/top_selling_row.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/dynamic_filter_row.dart';

class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final media = MediaQuery.of(context).size;

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
                            "Welcome back, John!",
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
           //The static search bar that pins when scrolling
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
                   hint: "Search for products",
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
               EdgeInsets.symmetric(vertical: 16, horizontal: media.width * 0.05),
               child: SizedBox(
                height: media.height * 0.16,
                child: AutoMovingAdsCarousel()),
            ),
            ),
            //=========== The filtering chips =========
              SliverToBoxAdapter(
                child: DynamicFilterRow(),
              ),
            //========= Most Selling ==========
            SliverToBoxAdapter(
              child: TopSellingRow(),
            )
           ],
           
            ),
         ),
       ),
      );
     
  }
}