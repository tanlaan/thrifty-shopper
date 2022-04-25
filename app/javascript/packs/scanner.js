var btn = document.getElementById("scan")
btn.addEventListener('click', barcodeStartScan)

function throttle(callback, limit) {
  var waiting = false;
  return function () {
    if (!waiting) {
      callback.apply(this, arguments)
      waiting = true
      setTimeout(function () {
        waiting = false;
      }, limit);
    }
  }
}

function loadProductPage(result){
  console.log(result.codeResult.code)
  qry = document.getElementById('query')
  qry.value = result.codeResult.code
  
  frm = document.getElementsByTagName('form')[0]
  frm.submit()
  
}

function barcodeStartScan(){ 
  Quagga.init(
    {
      inputStream: {
        type: "LiveStream",
        constraints: {
          width: 600,
          height: 400,
          facingMode: "environment" // or user
        }
      },
      locator: {
        patchSize: "medium",
        halfSample: true,
        debug:false
      },
      numOfWorkers: 4,
      decoder: {
        readers: ["upc_reader"]
      },
      locate: true
    },
    function (err) {
      if (err) {
        return console.log(err);
      }
      console.log('Quagga start')
      Quagga.start();
    }
  );
  console.log('load ondetected?')
  Quagga.onDetected(throttle(loadProductPage, 250));
};