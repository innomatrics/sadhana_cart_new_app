import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/api_provider.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/shiprocket_api_services.dart';
import 'package:dio/dio.dart';

class OrderTrackingPage extends ConsumerWidget {
  final OrderModel order;

  const OrderTrackingPage({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipRocket = ShiprocketApiServices(
      Dio(),
      ref.read(tokenManagerProvider),
    );
    final trackOrderProvider =
        FutureProvider.family<Map<String, dynamic>, String>((
          ref,
          shipmentId,
        ) async {
          return await shipRocket.trackOrder(shipmentId);
        });
    final trackingAsync = ref.watch(
      trackOrderProvider(order.shipmentId.toString()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Tracking',
          style: TextStyle(color: AppColor.dartPrimaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: trackingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Unable to load tracking information',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => ref.refresh(
                    trackOrderProvider(order.shipmentId.toString()),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        data: (trackingData) {
          return _buildTrackingUI(context, trackingData, order);
        },
      ),
    );
  }

  Widget _buildTrackingUI(
    BuildContext context,
    Map<String, dynamic> trackingData,
    OrderModel order,
  ) {
    // Check if there's an error message from Shiprocket
    final trackingInfo = trackingData['tracking_data'];
    final errorMessage = trackingInfo?['error']?.toString();

    if (errorMessage != null && errorMessage.isNotEmpty) {
      return _buildWaitingForTrackingUI(errorMessage, order);
    }

    final shipmentTrack = trackingInfo?['shipment_track']?[0];
    final activities =
        trackingInfo?['shipment_track_activities'] as List<dynamic>?;
    final currentStatus =
        shipmentTrack?['current_status']?.toString() ?? 'Order Placed';
    final awbCode = shipmentTrack?['awb_code']?.toString() ?? 'Awaiting AWB';
    final etd = trackingInfo?['etd']?.toString();

    // Check if we have valid tracking data
    final hasValidTracking =
        shipmentTrack != null &&
        shipmentTrack['id'] != 0 &&
        awbCode.isNotEmpty &&
        awbCode != 'Awaiting AWB';

    if (!hasValidTracking) {
      return _buildWaitingForTrackingUI(
        "Tracking information will be available soon. Please check back later.",
        order,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.shiprocketOrderId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('AWB Number: $awbCode'),
                  Text('Status: ${_getStatusText(currentStatus)}'),
                  if (etd != null)
                    Text('Estimated Delivery: ${_formatDate(etd)}'),
                  Text('Payment Method: ${order.paymentMethod}'),
                  Text(
                    'Total Amount: ₹${order.totalAmount.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Progress Timeline
          _buildProgressTimeline(currentStatus, activities ?? []),

          const SizedBox(height: 24),

          // Tracking Activities
          if (activities != null && activities.isNotEmpty)
            _buildTrackingActivities(activities),

          const SizedBox(height: 24),

          // Delivery Information
          if (shipmentTrack != null && hasValidTracking)
            _buildDeliveryInfo(shipmentTrack),
        ],
      ),
    );
  }

  Widget _buildWaitingForTrackingUI(String message, OrderModel order) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 80, color: Colors.orange.shade300),
            const SizedBox(height: 24),
            Text(
              'Tracking Pending',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.dartPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Order ID',
                      order.shiprocketOrderId.toString(),
                    ),
                    _buildInfoRow('Status', 'Order Confirmed'),
                    _buildInfoRow('Payment', order.paymentMethod ?? 'N/A'),
                    _buildInfoRow(
                      'Amount',
                      '₹${order.totalAmount.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tracking information usually appears within 2-4 hours after order confirmation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTimeline(
    String currentStatus,
    List<dynamic> activities,
  ) {
    final statusSteps = _getStatusSteps();
    final currentStepIndex = _getCurrentStepIndex(currentStatus, statusSteps);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...statusSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = index < currentStepIndex;
              final isCurrent = index == currentStepIndex;

              return _buildTimelineStep(
                step['title']!,
                step['description']!,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLast: index == statusSteps.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
    String title,
    String description, {
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : isCurrent
                    ? AppColor.dartPrimaryColor
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : isCurrent
                  ? const Icon(Icons.circle, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted
                        ? Colors.green
                        : isCurrent
                        ? AppColor.dartPrimaryColor
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingActivities(List<dynamic> activities) {
    if (activities.isEmpty) {
      return const SizedBox.shrink(); // Don't show empty activities section
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...activities.map((activity) => _buildActivityItem(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(dynamic activity) {
    final date = activity['date']?.toString() ?? '';
    final status = activity['status']?.toString() ?? '';
    final activityText = activity['activity']?.toString() ?? '';
    final location = activity['location']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: AppColor.dartPrimaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(activityText, style: const TextStyle(fontSize: 16)),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
                if (status.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Status: $status',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(Map<String, dynamic> shipmentTrack) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Consignee',
              shipmentTrack['consignee_name']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Destination',
              shipmentTrack['destination']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Origin',
              shipmentTrack['origin']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Weight',
              '${shipmentTrack['weight']?.toString() ?? 'N/A'} kg',
            ),
            _buildInfoRow(
              'Packages',
              shipmentTrack['packages']?.toString() ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  // Helper methods
  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PICKED UP':
        return 'Picked Up';
      case 'IN TRANSIT':
        return 'In Transit';
      case 'OUT FOR DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'ORDER PLACED':
        return 'Order Confirmed';
      default:
        return status;
    }
  }

  List<Map<String, String>> _getStatusSteps() {
    return [
      {
        'title': 'Order Confirmed',
        'description': 'Your order has been confirmed',
      },
      {'title': 'Processing', 'description': 'Preparing your shipment'},
      {'title': 'Shipped', 'description': 'Item has been shipped'},
      {'title': 'In Transit', 'description': 'Item is in transit'},
      {'title': 'Out for Delivery', 'description': 'Item is out for delivery'},
      {'title': 'Delivered', 'description': 'Item has been delivered'},
    ];
  }

  int _getCurrentStepIndex(
    String currentStatus,
    List<Map<String, String>> steps,
  ) {
    final status = currentStatus.toUpperCase();
    if (status.contains('DELIVERED')) return 5;
    if (status.contains('OUT FOR DELIVERY')) return 4;
    if (status.contains('IN TRANSIT')) return 3;
    if (status.contains('SHIPPED') || status.contains('PICKED UP')) return 2;
    if (status.contains('PROCESSING')) return 1;
    return 0; // Order Confirmed
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
