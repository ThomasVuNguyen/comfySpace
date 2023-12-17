import 'dart:io';

import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';

class NetworkScanPage extends StatefulWidget {
  const NetworkScanPage({super.key});

  @override
  State<NetworkScanPage> createState() => _NetworkScanPageState();
}

class _NetworkScanPageState extends State<NetworkScanPage> {
  late String ip;
  @override
  void initState(){
    super.initState();
  }
  Future<List<Host>> HostScan() async{
    final info = NetworkInfo();
    final wifiGateway = await info.getWifiIP();
    ip = wifiGateway!;
    print(wifiGateway);
    List<String>? IpSplit = wifiGateway.split('.');
    String NetworkIP = '${IpSplit[0]}.${IpSplit[1]}.${IpSplit[2]}';
    final scanner = LanScanner();

    final List<Host> hosts = await scanner.quickIcmpScanAsync(NetworkIP);
    print(hosts.toString());

    return scanner.quickIcmpScanAsync(NetworkIP);

    /*List<String> devices = [];

    for (Host host in hosts){
      devices.add(host.internetAddress.address);
      //ActiveHost currenthost = ActiveHost(internetAddress: InternetAddress(host.internetAddress.address));
      //String? deviceName = await currenthost.openPorts.toString();
      //devices.add(deviceName!);
    }
    print(devices);*/
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Host>>(
        future: HostScan(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return Center(
              child: ListView.builder(
              itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                return NetworkDeviceCard(IpAddress: snapshot.data![index].internetAddress.address);
                  }
              ),
            );
          }
          else{
            return Text("loading");
          }
        },

      ),
    );
  }
}

class NetworkDeviceCard extends StatefulWidget {
  const NetworkDeviceCard({super.key, required this.IpAddress});
  final String IpAddress;

  @override
  State<NetworkDeviceCard> createState() => _NetworkDeviceCardState();
}

class _NetworkDeviceCardState extends State<NetworkDeviceCard> {
  Future<String?> searchMDNS() async{
    ActiveHost CurrentHost = ActiveHost(internetAddress: InternetAddress(widget.IpAddress));
    var hostMDNS = await CurrentHost.mdnsInfo;
    var hostName = await CurrentHost.hostName;
    return hostName;
    //return hostMDNS!.mdnsName;
}
  Future<void> HostNameTest() async{
    ActiveHost CurrentHost = ActiveHost(internetAddress: InternetAddress('10.0.0.85'));
    var hostName = await CurrentHost.hostName;
    print(hostName);
  }
  @override
  void initState(){
    super.initState();
    HostNameTest();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width-40,
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(top:16.0, bottom: 16.0, left: 16.0, right: 16.0),
                trailing: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect( borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: (){
                              }, icon: const Icon(Icons.add, color: Color(0xffEADDFF),))
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: (){
                },
                shape: RoundedRectangleBorder(side: BorderSide(width: 2, color: Theme.of(context).colorScheme.tertiary), borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(8.0), topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)), ),
                title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.IpAddress, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),),
                    FutureBuilder(future: searchMDNS(), builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        if (snapshot.data == null){
                          return Text('no dnms', style: GoogleFonts.poppins(fontSize: 16));
                        }
                        else
                          {
                            return Text(snapshot.data!, style: GoogleFonts.poppins(fontSize: 16));
                          }

                      }
                      else{
                        return Text('loading', style: GoogleFonts.poppins(fontSize: 16));                      }
                    }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}