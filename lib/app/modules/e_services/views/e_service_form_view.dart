import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/e_service_form_controller.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class EServiceFormView extends GetView<EServiceFormController> {
  @override
  Widget build(BuildContext context) {
    print(controller.eService.value);
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.isCreateForm() ? "Create Service".tr : controller.eService.value.name ?? '',
              style: context.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () async {
              controller.isCreateForm()
                  ? await Get.offAndToNamed(Routes.E_SERVICES)
                  : await Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': controller.eService.value, 'heroTag': 'service_form_back'});
            },
          ),
          elevation: 0,
          actions: [
            new IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: new Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 28,
              ),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    if (controller.isCreateForm()) {
                      controller.createEServiceForm();
                    } else {
                      controller.updateEServiceForm();
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.accentColor,
                  child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                ),
              ),
              if (controller.isCreateForm()) SizedBox(width: 10),
              if (controller.isCreateForm())
                MaterialButton(
                  onPressed: () {
                    controller.createEServiceForm(createOptions: true);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.accentColor.withOpacity(0.2),
                  child: Text("Save & Add Options".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.accentColor))),
                  elevation: 0,
                ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.eServiceForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.isCreateForm())
                  HorizontalStepperWidget(
                    steps: [
                      StepWidget(
                        title: Text(
                          ("Service details".tr).substring(0, min("Service details".tr.length, 15)),
                        ),
                        index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                      StepWidget(
                        title: Text(
                          ("Options details".tr).substring(0, min("Options details".tr.length, 15)),
                        ),
                        color: Get.theme.focusColor,
                        index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ],
                  ),
                Text("Service details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Fill the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImagesFieldWidget(
                    label: "Images".tr,
                    tag: controller.eServiceForm.hashCode.toString(),
                    initialImages: controller.eService.value.images,
                    uploadCompleted: (uuid) {
                      controller.eService.update((val) {
                        val.images = val.images ?? [];
                        val.images.add(new Media(id: uuid));
                      });
                    },
                    reset: (uuids) {
                      controller.eService.update((val) {
                        val.images.clear();
                      });
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.eService.value.name = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.eService.value.name,
                  hintText: "Post Party Cleaning".tr,
                  labelText: "Name".tr,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.eService.value.description = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  keyboardType: TextInputType.multiline,
                  initialValue: controller.eService.value.description,
                  hintText: "Description for Post Party Cleaning".tr,
                  labelText: "Description".tr,
                ),
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Categories".tr,
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              final selectedValues = await showDialog<Set<Category>>(
                                context: context,
                                builder: (BuildContext context) {
                                  return MultiSelectDialog(
                                    title: "Select Categories".tr,
                                    submitText: "Submit".tr,
                                    cancelText: "Cancel".tr,
                                    items: controller.getMultiSelectCategoriesItems(),
                                    initialSelectedValues: controller.categories
                                        .where(
                                          (category) => controller.eService.value.categories?.where((element) => element.id == category.id)?.isNotEmpty ?? false,
                                        )
                                        .toSet(),
                                  );
                                },
                              );
                              controller.eService.update((val) {
                                val.categories = selectedValues?.toList();
                              });
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.1),
                            child: Text("Select".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.eService.value?.categories?.isEmpty ?? true) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Select categories".tr,
                              style: Get.textTheme.caption,
                            ),
                          );
                        } else {
                          return buildCategories(controller.eService.value);
                        }
                      })
                    ],
                  ),
                ),
                Obx(() {
                  if (controller.eProviders.length > 1)
                    return Container(
                      padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Providers".tr,
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  final selectedValue = await showDialog<EProvider>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectDialog(
                                        title: "Select Provider".tr,
                                        submitText: "Submit".tr,
                                        cancelText: "Cancel".tr,
                                        items: controller.getSelectProvidersItems(),
                                        initialSelectedValue: controller.eProviders.firstWhere(
                                          (element) => element.id == controller.eService.value.eProvider?.id,
                                          orElse: () => new EProvider(),
                                        ),
                                      );
                                    },
                                  );
                                  controller.eService.update((val) {
                                    val.eProvider = selectedValue;
                                  });
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.accentColor.withOpacity(0.1),
                                child: Text("Select".tr, style: Get.textTheme.subtitle1),
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                              ),
                            ],
                          ),
                          Obx(() {
                            if (controller.eService.value?.eProvider == null) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Select providers".tr,
                                  style: Get.textTheme.caption,
                                ),
                              );
                            } else {
                              return buildProvider(controller.eService.value);
                            }
                          })
                        ],
                      ),
                    );
                  else if (controller.eProviders.length == 1) {
                    controller.eService.value.eProvider = controller.eProviders.first;
                    return SizedBox();
                  } else {
                    return SizedBox();
                  }
                }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onSaved: (input) => controller.eService.value.price = (double.tryParse(input) ?? 0),
                        validator: (input) => (double.tryParse(input) ?? 0) <= 0 ? "Should be number more than 0".tr : null,
                        initialValue: controller.eService.value.price?.toString(),
                        hintText: "23.00".tr,
                        labelText: "Price".tr,
                        suffix: Text(Get.find<SettingsService>().setting.value.defaultCurrency),
                      ),
                    ),
                    Expanded(
                      child: TextFieldWidget(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onSaved: (input) => controller.eService.value.discountPrice = double.tryParse(input),
                        validator: (input) => (input != "") && ((double.tryParse(input) ?? 0) <= 0) ? "Should be number more than 0".tr : null,
                        initialValue: (controller.eService.value.discountPrice ?? 0) > 0 ? controller.eService.value.discountPrice?.toString() : null,
                        hintText: "21.00".tr,
                        labelText: "Discount Price".tr,
                        suffix: Text(Get.find<SettingsService>().setting.value.defaultCurrency),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Price Unit".tr,
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        return ListTileTheme(
                          contentPadding: EdgeInsets.all(0.0),
                          horizontalTitleGap: 0,
                          dense: true,
                          textColor: Get.theme.hintColor,
                          child: ListBody(
                            children: [
                              RadioListTile(
                                value: "hourly",
                                groupValue: controller.eService.value.priceUnit,
                                selected: controller.eService.value.priceUnit == "hourly",
                                title: Text("Hourly".tr),
                                controlAffinity: ListTileControlAffinity.trailing,
                                onChanged: (checked) {
                                  controller.eService.update((val) {
                                    val.priceUnit = "hourly";
                                  });
                                },
                              ),
                              RadioListTile(
                                value: "fixed",
                                groupValue: controller.eService.value.priceUnit,
                                title: Text("Fixed".tr),
                                selected: controller.eService.value.priceUnit == "fixed",
                                controlAffinity: ListTileControlAffinity.trailing,
                                onChanged: (checked) {
                                  controller.eService.update((val) {
                                    val.priceUnit = "fixed";
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.eService.value.quantityUnit = input,
                  initialValue: controller.eService.value.quantityUnit,
                  hintText: "Piece".tr,
                  labelText: "Quantity Unit".tr,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.eService.value.duration = input,
                  initialValue: controller.eService.value.duration,
                  validator: (input) => input.isNotEmpty && !RegExp(r"^[0-1][0-9]|2[0-3]|[1-9]:[0-5][0-9]").hasMatch(input) ? "Should be a valid time" : null,
                  hintText: "02:30".tr,
                  labelText: "Duration".tr,
                  keyboardType: TextInputType.datetime,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        return ListTileTheme(
                          contentPadding: EdgeInsets.all(0.0),
                          horizontalTitleGap: 0,
                          dense: true,
                          textColor: Get.theme.hintColor,
                          child: ListBody(
                            children: [
                              CheckboxListTile(
                                value: controller.eService.value.featured ?? false,
                                selected: controller.eService.value.featured ?? false,
                                title: Text("Featured".tr),
                                controlAffinity: ListTileControlAffinity.trailing,
                                onChanged: (checked) {
                                  controller.eService.update((val) {
                                    val.featured = checked;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildCategories(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_eService.categories?.length ?? 0, (index) {
              var _category = _eService.categories.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: _category.color))),
                decoration: BoxDecoration(
                    color: _category.color.withOpacity(0.2),
                    border: Border.all(
                      color: _category.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_eService.subCategories?.length ?? 0, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_eService.subCategories.elementAt(index).name, style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildProvider(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_eService.eProvider?.name ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Service".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This service will removed from your account".tr, style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                controller.deleteEService();
              },
            ),
          ],
        );
      },
    );
  }
}
