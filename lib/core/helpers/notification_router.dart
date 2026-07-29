import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invoify/core/routing/app_router.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/features/invoices/data/models/invoice_model.dart';

class NotificationRouter {
  NotificationRouter._();

  static bool isAppReady = false;
  static String? _pendingInvoiceId;

  static void markAppAsReady() {
    isAppReady = true;
    checkAndHandlePendingNotification();
  }

  static void checkAndHandlePendingNotification() {
    if (_pendingInvoiceId != null && isAppReady) {
      final id = _pendingInvoiceId!;
      _pendingInvoiceId = null;
      handleInvoiceNavigation(id);
    }
  }

  static Future<void> handleInvoiceNavigation(dynamic payload) async {
    String? invoiceId;

    if (payload is String) {
      if (payload.trim().startsWith('{')) {
        try {
          final Map<String, dynamic> data = jsonDecode(payload);
          invoiceId = (data['invoiceId'] ?? data['InvoiceId'] ?? data['id'])?.toString();
        } catch (_) {
          invoiceId = payload;
        }
      } else {
        invoiceId = payload;
      }
    } else if (payload is Map) {
      invoiceId = (payload['invoiceId'] ?? payload['InvoiceId'] ?? payload['id'])?.toString();
    }

    if (invoiceId == null || invoiceId.isEmpty) return;

    if (!isAppReady) {
      debugPrint('App layout not ready yet. Storing pending invoiceId: $invoiceId');
      _pendingInvoiceId = invoiceId;
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoiceId)
          .get();

      if (doc.exists && doc.data() != null) {
        final invoiceModel = InvoiceModel.fromJson(doc.data()!, docId: doc.id);
        final invoiceEntity = invoiceModel.toEntity();

        final navigator = navigatorKey.currentState;
        if (navigator != null) {
          await navigator.pushNamed(
            Routes.invoiceDetailsView,
            arguments: invoiceEntity,
          );
        }
      }
    } catch (e) {
      debugPrint('Error navigating to invoice details from notification: $e');
    }
  }
}
