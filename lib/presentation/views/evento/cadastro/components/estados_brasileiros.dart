import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

const List<String> listaEstados = <String>[
  '',
  'RS',
  'RO',
  'AC',
  'AM',
  'RR',
  'PA',
  'AP',
  'TO',
  'MA',
  'PI',
  'CE',
  'RN',
  'PB',
  'PE',
  'AL',
  'SE',
  'BA',
  'MG',
  'ES',
  'RJ',
  'SP',
  'PR',
  'SC',
  'MS',
  'MT',
  'GO',
  'DF',
];

class DropdownEstadosBrasileiros extends StatefulWidget {
  final String value;
  final Function(String) callbackSelectUf;
  const DropdownEstadosBrasileiros({
    super.key,
    required this.value,
    required this.callbackSelectUf,
  });

  @override
  State<DropdownEstadosBrasileiros> createState() => _DropdownEstadosBrasileirosState();
}

String dropdownValue = "RS";

class _DropdownEstadosBrasileirosState extends State<DropdownEstadosBrasileiros> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 55,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          DropdownButton<String>(
            value: widget.value,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            onChanged: (String? value) {
              widget.callbackSelectUf(value!);
            },
            items: listaEstados.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
