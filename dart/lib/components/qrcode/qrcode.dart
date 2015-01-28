library qrcode_comp;

import 'package:angular/angular.dart' show Component, NgAttr, NgOneWay,
  NgOneWayOneTime;
import 'package:angular/angular.dart' as ng;
import 'dart:html' as dom;
import 'dart:async' as async;
import 'dart:js' as js;

@Component(
  selector: 'qrcode',
  template: '<div></div>',
  cssUrl: 'packages/pritunl/components/qrcode/qrcode.css'
)
class QrcodeComp implements ng.ShadowRootAware, ng.AttachAware {
  dom.Element qrcodeElem;
  var _curText;
  var _attached;

  var _text;
  @NgOneWay('text')
  void set text(String val) {
    this._text = val;
    if (this._attached == true) {
      this.buildQrcode();
    }
  }
  String get text {
    return this._text;
  }

  @NgOneWayOneTime('width')
  int width;

  @NgOneWayOneTime('height')
  int height;

  void buildQrcode() {
    if (this._curText == this.text) {
      return;
    }
    this._curText = this.text;
    var qrcodeElem = new dom.Element.div();

    var qrSettings = new js.JsObject.jsify({
      'text': this._curText,
      'width': this.width,
      'height': this.height,
      'colorDark': '#3276b1',
      'colorLight': '#fff'
    });

    new js.JsObject(js.context['QRCode'], [qrcodeElem, qrSettings]);

    new async.Timer(const Duration(milliseconds: 50), () {
      this.qrcodeElem.replaceWith(qrcodeElem);
      this.qrcodeElem = qrcodeElem;
    });
  }

  void onShadowRoot(dom.ShadowRoot root) {
    this.qrcodeElem = root.querySelector('div');
  }

  void attach() {
    this.buildQrcode();
    this._attached = true;
  }
}