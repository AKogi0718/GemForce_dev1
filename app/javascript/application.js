// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "@nathanvda/cocoon"
import "./products"

document.addEventListener("turbo:load", function() {
  // 既存のJavaScript処理
  initPostalCodeLookup();
  initToggleSwitches();
  initSequenceUpdates();

  // Cocoonのイベントハンドラーを初期化
  initCocoonHandlers();
});

// DOMContentLoadedイベントでも初期化（Turboのない環境向け）
document.addEventListener("DOMContentLoaded", function() {
  initCocoonHandlers();
});

function initPostalCodeLookup() {
  $('#client_postal_code').on('blur', function() {
    var postalCode = $(this).val().replace(/[^\d]/g, '');
    if (postalCode.length === 7) {
      $.ajax({
        url: 'https://zipcloud.ibsnet.co.jp/api/search',
        type: 'GET',
        dataType: 'jsonp',
        data: {
          zipcode: postalCode
        },
        success: function(data) {
          if (data.results) {
            var result = data.results[0];
            var address = result.address1 + result.address2 + result.address3;
            $('#client_address').val(address);
          }
        }
      });
    }
  });
}

function initToggleSwitches() {
  $('.custom-control-input').on('change', function() {
    var label = $(this).next('.custom-control-label');
    if ($(this).is(':checked')) {
      label.text('有効');
    } else {
      label.text('無効');
    }
  });
}

function initSequenceUpdates() {
  $('.nested-fields').each(function(index) {
    $(this).find('input[name$="[sequence]"]').val(index + 1);
  });
}

function initCocoonHandlers() {
  console.log('Cocoonハンドラーを初期化しています');

  // link_to_add_associationボタンの動作確認
  $('.add_fields').on('click', function(e) {
    console.log('追加ボタンがクリックされました');
  });

  // cocoonによる動的追加時のイベントハンドリング
  $(document).on('cocoon:before-insert', function(e, insertedItem) {
    console.log('要素が追加される前です');
  });

  $(document).on('cocoon:after-insert', function(e, insertedItem) {
    console.log('要素が追加されました');

    // シーケンス番号の更新
    var containerType = '';

    if ($(insertedItem).closest('#materials-container').length > 0) {
      containerType = 'materials';
    } else if ($(insertedItem).closest('#stone-parts-container').length > 0) {
      containerType = 'stone-parts';
    } else if ($(insertedItem).closest('#images-container').length > 0) {
      containerType = 'images';
    }

    updateSequenceNumbers(containerType);

    // ファイル選択のラベル更新
    $(insertedItem).find('.custom-file-input').on('change', function() {
      var fileName = $(this).val().split('\\').pop();
      $(this).next('.custom-file-label').html(fileName);
      // ファイル名フィールドに自動入力
      var filenameField = $(this).closest('tr').find('input[name$="[filename]"]');
      if (!filenameField.val()) {
        filenameField.val(fileName);
      }
    });

    // 石パーツの形式が変更されたときの処理
    $(insertedItem).find('.format-select').on('change', function() {
      var formatType = $(this).val();
      var sizeInfoField = $(this).closest('tr').find('input[name$="[size_info]"]');
      // サイズ情報のプレースホルダーを変更
      if (formatType === '石(〇〇×〇〇)') {
        sizeInfoField.attr('placeholder', '例: 101010 (1.0mm×1.0mm)');
      } else if (formatType === 'バーツ(〇〇〇mm)') {
        sizeInfoField.attr('placeholder', '例: 010 (10mm)');
      } else if (formatType === '1/〇〇〇形式') {
        sizeInfoField.attr('placeholder', '例: 100 (1/100)');
      } else {
        sizeInfoField.attr('placeholder', '特殊項目の名前');
      }
    });
  });

  $(document).on('cocoon:before-remove', function(e, item) {
    console.log('要素が削除される前です');
  });

  $(document).on('cocoon:after-remove', function() {
    console.log('要素が削除されました');
    updateSequenceNumbers();
  });
}

// シーケンス番号を更新する関数
function updateSequenceNumbers(containerType) {
  if (!containerType || containerType === 'materials') {
    $('#materials-container tr.nested-fields').each(function(index) {
      $(this).find('input[name$="[sequence]"]').val(index + 1);
    });
  }

  if (!containerType || containerType === 'stone-parts') {
    $('#stone-parts-container tr.nested-fields').each(function(index) {
      $(this).find('input[name$="[sequence]"]').val(index + 1);
    });
  }

  if (!containerType || containerType === 'images') {
    $('#images-container tr.nested-fields').each(function(index) {
      $(this).find('input[name$="[sequence]"]').val(index + 1);
    });
  }
}
