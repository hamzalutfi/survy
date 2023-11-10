import 'package:flutter/material.dart';
import 'package:wego/utils/constants/colors.dart';

class ServiceSelectableWidget extends StatelessWidget {
  final String serviceName;
  final Function onSelect;
  final Function onDeSelect;
  final bool isSelected;
  final bool isLocation;

  const ServiceSelectableWidget(
      {required this.serviceName,
      required this.onSelect,
      required this.onDeSelect,
      required this.isLocation,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => isSelected ? onDeSelect(serviceName) : onSelect(serviceName),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  children: [
                    isLocation
                        ? Icon(
                            Icons.location_on,
                            color: Colors.red,
                          )
                        : Container(),
                    Expanded(
                      child: Text(
                        serviceName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    ),
                  ],
                )),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle,
              color: isSelected ? primaryColor : Colors.grey.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
