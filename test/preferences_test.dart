import 'package:test/test.dart';
import 'dart:convert' show json;

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/preferences.dart';

void main() {

  test('serialize empty preferences', () {
    expect(json.encoder.convert(Preferences()), '{"endpoint":"","appkey":"","wallets":[]}');
  });

  test('serialize with endpoint and aqppkey', () {
    Preferences p = Preferences();

    p.endpoint = "this is the endpoint";
    expect(json.encoder.convert(p), '{"endpoint":"this is the endpoint","appkey":"","wallets":[]}');

    p.appkey = "this is the appkey";
    expect(json.encoder.convert(p), '{"endpoint":"this is the endpoint","appkey":"this is the appkey","wallets":[]}');
  });

  test('serialize with wallets', () {
    Preferences p = Preferences();

    p.endpoint = "endpoint";
    p.appkey = "appkey";

    p.wallets = [
      EasyWallet("wallet1")
    ];
    expect(json.encoder.convert(p), '{"endpoint":"endpoint","appkey":"appkey","wallets":[{"address":"wallet1"}]}');

    p.wallets.add(EasyWallet("wallet2"));
    expect(json.encoder.convert(p), '{"endpoint":"endpoint","appkey":"appkey","wallets":[{"address":"wallet1"},{"address":"wallet2"}]}');
  });

  test('deserialize preferences', () {
    //
    // empty values
    //
    Preferences p = Preferences.fromJson('{"endpoint":"","appkey":"","wallets":[]}');
    expect(p.endpoint, ""); 
    expect(p.appkey, "");
    expect(p.wallets.isEmpty, true);

    //
    // some values
    //
    p = Preferences.fromJson('{"endpoint":"an endpoint","appkey":"an appkey","wallets":[{"address":"a wallet"}]}');
    expect(p.endpoint, "an endpoint"); 
    expect(p.appkey, "an appkey");
    expect(p.wallets.length, 1); expect(p.wallets[0].address, "a wallet");
  });

  test('deserialize preferences with missing values', () {
    //
    // no wallets
    //
    Preferences p = Preferences.fromJson('{"endpoint":"","appkey":""}');
    expect(p.endpoint, ""); 
    expect(p.appkey, "");
    expect(p.wallets.isEmpty, true);

    //
    // no endpoint
    //
    p = Preferences.fromJson('{"appkey":"","wallets":[{"address":"a wallet"}]}');
    expect(p.endpoint, ""); 
    expect(p.appkey, "");
    expect(p.wallets.isEmpty, false);

    //
    // no appkey
    //
    p = Preferences.fromJson('{"endpoint":"endpoint","wallets":[{"address":"a wallet"}]}');
    expect(p.endpoint, "endpoint"); 
    expect(p.appkey, "");
    expect(p.wallets.isEmpty, false);

    //
    // no values
    //
    p = Preferences.fromJson('{}');
    expect(p.endpoint, ""); 
    expect(p.appkey, "");
    expect(p.wallets.isEmpty, true);
  });
}