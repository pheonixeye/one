// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/router/router.dart';

class GridModel extends Equatable {
  final String asset;
  final String title;
  final String path;

  const GridModel({
    required this.asset,
    required this.title,
    required this.path,
  });

  @override
  List<Object> get props => [asset, title];
}

List<GridModel> gridModelList(BuildContext context) => [
  GridModel(
    asset: AppAssets.drugs,
    title: context.loc.doctorDrugs,
    path: AppRouter.drugs,
  ),
  GridModel(
    asset: AppAssets.labs,
    title: context.loc.laboratoryRequests,
    path: AppRouter.labs,
  ),
  GridModel(
    asset: AppAssets.radiology,
    title: context.loc.radiology,
    path: AppRouter.rads,
  ),
  GridModel(
    asset: AppAssets.procedures,
    title: context.loc.procedures,
    path: AppRouter.procedures,
  ),
  GridModel(
    asset: AppAssets.supplies,
    title: context.loc.supplies,
    path: AppRouter.supplies,
  ),
  GridModel(
    asset: AppAssets.documents,
    title: context.loc.documents,
    path: AppRouter.documents,
  ),
];
