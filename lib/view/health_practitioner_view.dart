import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/health_practitioner.dart';
import '../model/health_practitioner_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util/widget_util.dart';

class HealthPractitionerView extends StatefulWidget {
  HealthPractitionerData? healthPractitionerData;

  HealthPractitionerView({Key? key, this.healthPractitionerData}) : super(key: key);

  @override
  State<HealthPractitionerView> createState() => _HealthPractitionerViewState();
}

class _HealthPractitionerViewState extends State<HealthPractitionerView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hpNameController, _pnController, _emailController, _telController;
  int hpId = -1;
  String btnText = '';

  @override
  void initState() {
    super.initState();
    _hpNameController = TextEditingController();
    _pnController = TextEditingController();
    _emailController = TextEditingController();
    _telController = TextEditingController();
    if (widget.healthPractitionerData != null && widget.healthPractitionerData?.id != null) {
      hpId = widget.healthPractitionerData?.id ?? -1;
      _hpNameController.text = widget.healthPractitionerData!.hp;
      _pnController.text = widget.healthPractitionerData!.pn ?? '';
      _emailController.text = widget.healthPractitionerData!.email ?? '';
      _telController.text = widget.healthPractitionerData!.tel ?? '';
    }
  }

  @override
  void dispose() {
    _hpNameController.dispose();
    _pnController.dispose();
    _emailController.dispose();
    _telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    btnText = AppLocalizations.of(context)!.saveBtn;
    if (hpId > 0) {
      btnText = AppLocalizations.of(context)!.updateBtn;
    }
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.medicalServices)),
    body:  Form(
        key: _formKey,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers:[
            SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverList(
              delegate: SliverChildListDelegate(
              <Widget>[
                TextFormField(
                  controller: _hpNameController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.serviceName, filled: false, fillColor: Colors.purple,
                      suffixIcon: const Icon(
                        Icons.medical_services_outlined,
                      )
                  ),
                  maxLines: 1,
                ),
                TextFormField(
                  controller: _pnController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.practiceNumber, filled: false, fillColor: Colors.purple,

                  ),
                  maxLines: 1,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email, filled: false, fillColor: Colors.purple,
                      suffixIcon: const Icon(
                        Icons.email,
                      )
                  ),
                  maxLines: 1,
                ),
                TextFormField(
                  controller: _telController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.telephone, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.phone_android,
                    )
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                ),
                Consumer<HealthPractitioner> (builder: (context, practitionerRepo, child) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        persistHP(practitionerRepo);
                      }
                    },
                    child: Text(btnText),
                  );
                })
                ]
              ))
            )
          ]
        )
    ));
  }

  void persistHP(HealthPractitioner practitionerRepo) async {
    int? id = hpId > 0 ? hpId : null;
    practitionerRepo.persist(hp: _hpNameController.text, pn: _pnController.text,
        email: _emailController.text, tel: _telController.text, id: id).
    then((value) => {
      showDlgOkCancel(context, 'Service Persisted', 'The service details have '
          'been stored').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Service Not updated', 'Something is not right. The service info was not stored').then((value) => false)
    });
  }
}
