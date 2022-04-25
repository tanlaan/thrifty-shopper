
document.addEventListener('DOMContentLoaded', () => {
  // Add Scan Button Event
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
        Quagga.start();
      }
    );
    Quagga.onDetected(throttle(loadProductPage, 250));
  };

  // Functions to open and close a modal
  function openModal($el) {
    $el.classList.add('is-active');
  }

  function closeModal($el) {
    $el.classList.remove('is-active');
    Quagga.stop();
  }

  function closeAllModals() {
    (document.querySelectorAll('.modal') || []).forEach(($modal) => {
      closeModal($modal);
    });
  }

  // Add a click event on buttons to open a specific modal
  (document.querySelectorAll('.js-modal-trigger') || []).forEach(($trigger) => {
    const modal = $trigger.dataset.target;
    const $target = document.getElementById(modal);

    $trigger.addEventListener('click', () => {
      openModal($target);
    });
  });

  // Add a click event on various child elements to close the parent modal
  (document.querySelectorAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button') || []).forEach(($close) => {
    const $target = $close.closest('.modal');

    $close.addEventListener('click', () => {
      closeModal($target);
    });
  });

  // Add a keyboard event to close all modals
  document.addEventListener('keydown', (event) => {
    const e = event || window.event;

    if (e.keyCode === 27) { // Escape key
      closeAllModals();
    }
  });
});