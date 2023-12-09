import 'package:custome_mobile/data/models/package_model.dart';
import 'package:flutter/material.dart';

class CalculatorProvider extends ChangeNotifier {
  String _syrianExchangeValue = "8585";
  String get syrianExchangeValue => _syrianExchangeValue;
  String _syrianTotalValue = "0";
  String get syrianTotalValue => _syrianTotalValue;
  String _totalValueWithEnsurance = "0";
  String get totalValueWithEnsurance => totalValueWithEnsurance;

  Package? _selectedPackage;
  Package? get selectedPackage => _selectedPackage;
  Origin? _selectedOrigin;
  Origin? get selectedOrigin => _selectedOrigin;

  String _wieghtUnit = "";
  String get wieghtUnit => _wieghtUnit;
  String _wieghtLabel = "الوزن";
  String get wieghtLabel => _wieghtLabel;

  bool _valueEnabled = true;
  bool get valueEnabled => _valueEnabled;
  bool _allowexport = false;
  bool get allowexport => _allowexport;
  bool _fillorigin = false;
  bool get fillorigin => _fillorigin;
  bool _originerror = false;
  bool get originerror => _originerror;
  bool _feeerror = false;
  bool get feeerror => _feeerror;
  bool _isfeeequal001 = false;
  bool get isfeeequal001 => _isfeeequal001;
  bool _isBrand = false;
  bool get isBrand => _isBrand;
  bool _brandValue = false;
  bool get brandValue => _brandValue;
  bool _rawMaterialValue = false;
  bool get rawMaterialValue => _rawMaterialValue;
  bool _industrialValue = false;
  bool get industrialValue => _industrialValue;
  bool _isTubes = false;
  bool get isTubes => _isTubes;
  bool _tubesValue = false;
  bool get tubesValue => _tubesValue;
  bool _isLycra = false;
  bool get isLycra => _isLycra;
  bool _lycraValue = false;
  bool get lycraValue => _lycraValue;
  bool _isColored = false;
  bool get isColored => _isColored;
  bool _colorValue = false;
  bool get colorValue => _colorValue;
  bool _showunit = false;
  bool get showunit => _showunit;
  bool _isdropdwonVisible = false;
  bool get isdropdwonVisible => _isdropdwonVisible;

  initProvider() {
    _syrianExchangeValue = "8585";
    _syrianTotalValue = "0";
    _totalValueWithEnsurance = "0";
    _selectedPackage;
    _selectedOrigin;
    _wieghtUnit = "";
    _wieghtLabel = "الوزن";
    _valueEnabled = true;
    _allowexport = false;
    _fillorigin = false;
    _originerror = false;
    _feeerror = false;
    _isfeeequal001 = false;
    _isBrand = false;
    _brandValue = false;
    _rawMaterialValue = false;
    _industrialValue = false;
    _isTubes = false;
    _tubesValue = false;
    _isLycra = false;
    _lycraValue = false;
    _isColored = false;
    _colorValue = false;
    _showunit = false;
    _isdropdwonVisible = false;
    notifyListeners();
  }
}
