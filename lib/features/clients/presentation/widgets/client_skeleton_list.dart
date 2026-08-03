import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'client_card.dart';

class ClientSkeletonList extends StatelessWidget {
  const ClientSkeletonList({super.key});

  static final List<ClientEntity> _dummyClients = List.generate(
    5,
    (index) => ClientEntity(
      clientId: 'dummy_$index',
      name: 'Client Name Placeholder',
      email: 'client.email@example.com',
      phone: '+1 234 567 8900',
      address: '123 Business Street, Suite 400',
    ),
  );

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: ListView.separated(
      padding: EdgeInsets.only(bottom: 90.h),
      itemCount: _dummyClients.length,
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) => ClientCard(
        client: _dummyClients[index],
        onEdit: () {},
        onDelete: () {},
      ),
    ),
  );
}
