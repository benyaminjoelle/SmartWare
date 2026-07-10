import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/client_home_controller.dart';

class FilteringMenu extends StatelessWidget{
  const FilteringMenu({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientHomeController>();
    final theme = Theme.of(context);
    final color = theme.colorScheme; 
    final media = MediaQuery.of(context).size;
    return SafeArea(
     child: DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            //Handle
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: color.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
                
        //Title
        Center(
          child: Text(
            "filtering".tr, 
            style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center),
        ),
        const Divider(height: 24, thickness: 0.5),

              // 2. Scrollable Body Content (Takes the scrollController to drive sheet expansion)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    Text("Categories", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    
                    // PLACEHOLDER: Your checkboxes, range sliders, or buttons go here
                    const Text("Filter attributes go here..."),
                    
                    const SizedBox(height: 100)
        ],
         ),
        ),
        ]
        ));
        }
     )
    );
              
  
  }
}