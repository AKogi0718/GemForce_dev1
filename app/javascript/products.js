
// products.js - 商品管理画面専用のJavaScript
// ESモジュールとしてjQueryとSelect2をインポート
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;
import "select2";

console.log('products.js が読み込まれました');
// 以下は既存のコード
console.log('products.js が読み込まれました');

document.addEventListener("turbo:load", function() {
  console.log('商品画面でTurbo:loadイベントが発生しました');
  setupProductFormHandlers();
});

document.addEventListener("DOMContentLoaded", function() {
  console.log('商品画面でDOMContentLoadedイベントが発生しました');
  setupProductFormHandlers();
});

function setupProductFormHandlers() {
  console.log("商品フォームハンドラーを初期化しています");

  // 地金追加ボタンのデバッグ
  console.log("地金追加ボタンを探しています");
  var addMaterialBtn = document.querySelector('a[data-association-insertion-node="#materials-container"]');
  if (addMaterialBtn) {
    console.log("地金追加ボタンが見つかりました:", addMaterialBtn);

    // ネイティブクリックイベントの監視（デバッグ用）
    addMaterialBtn.addEventListener('click', function(e) {
      console.log('地金追加ボタンがクリックされました (ネイティブハンドラー)');
    });

    // Cocoonイベントを監視
    document.addEventListener('cocoon:after-insert', function(e) {
      if (e.detail && e.detail.closest('#materials-container')) {
        console.log("地金行が追加されました");
        updateSequenceNumbers('materials');
      }
    });

    document.addEventListener('cocoon:after-remove', function(e) {
      if (e.target && e.target.closest('#materials-container')) {
        console.log("地金行が削除されました");
        updateSequenceNumbers('materials');
      }
    });
  } else {
    console.log('地金追加ボタンが見つかりません');
  }

  // 石パーツ追加ボタンのデバッグ
  console.log("石パーツ追加ボタンを探しています");
  var addStonePartBtn = document.querySelector('a[data-association-insertion-node="#stone-parts-container"]');
  if (addStonePartBtn) {
    console.log("石パーツ追加ボタンが見つかりました:", addStonePartBtn);

    // ネイティブクリックイベントの監視（デバッグ用）
    addStonePartBtn.addEventListener('click', function(e) {
      console.log('石パーツ追加ボタンがクリックされました (ネイティブハンドラー)');
    });

    // Cocoonイベントを監視
    document.addEventListener('cocoon:after-insert', function(e) {
      if (e.detail && e.detail.closest('#stone-parts-container')) {
        console.log("石パーツ行が追加されました");
        updateSequenceNumbers('stone-parts');

        // フォーマット選択の変更イベントを設定
        setupFormatSelect(e.detail);

        // 新しく追加された行にSelect2を初期化
        $(e.detail).find('.select2-with-tags').each(function() {
          initializeSelect2ForElement(this);
        });
      }
    });

    document.addEventListener('cocoon:after-remove', function(e) {
      if (e.target && e.target.closest('#stone-parts-container')) {
        console.log("石パーツ行が削除されました");
        updateSequenceNumbers('stone-parts');
      }
    });
  } else {
    console.log('石パーツ追加ボタンが見つかりません');
  }

  // jQueryイベント（確実に動作するための二重対策）
  $(document).on('click', 'a[data-association-insertion-node="#materials-container"]', function(e) {
    console.log('地金追加ボタンがクリックされました (jQueryハンドラー)');
  });

  $(document).on('click', 'a[data-association-insertion-node="#stone-parts-container"]', function(e) {
    console.log('石パーツ追加ボタンがクリックされました (jQueryハンドラー)');
  });

  // 既存の石パーツ行にフォーマット選択イベントを設定
  document.querySelectorAll('#stone-parts-container .nested-fields').forEach(function(row) {
    setupFormatSelect(row);
  });

  // 既存の行のシーケンス番号を初期化
  updateSequenceNumbers('materials');
  updateSequenceNumbers('stone-parts');

  // Select2の初期化
  initializeSelect2();
}

// シーケンス番号を更新する関数
function updateSequenceNumbers(containerType) {
  if (containerType === 'materials') {
    document.querySelectorAll('#materials-container .nested-fields').forEach(function(row, index) {
      var sequenceField = row.querySelector('input[name$="[sequence]"]');
      if (sequenceField) {
        sequenceField.value = index + 1;
      }
    });
  } else if (containerType === 'stone-parts') {
    document.querySelectorAll('#stone-parts-container .nested-fields').forEach(function(row, index) {
      var sequenceField = row.querySelector('input[name$="[sequence]"]');
      if (sequenceField) {
        sequenceField.value = index + 1;
      }
    });
  }
}

// 石パーツの形式が変更されたときの処理を設定
function setupFormatSelect(row) {
  var formatSelect = row.querySelector('.format-select');
  var sizeInfoField = row.querySelector('input[name$="[size_info]"]');

  if (formatSelect && sizeInfoField) {
    // 初期値に基づいてプレースホルダーを設定
    updateSizeInfoPlaceholder(formatSelect.value, sizeInfoField);

    // 変更イベントを監視
    formatSelect.addEventListener('change', function() {
      updateSizeInfoPlaceholder(this.value, sizeInfoField);
    });
  }
}

// サイズ情報のプレースホルダーを更新
function updateSizeInfoPlaceholder(formatType, sizeInfoField) {
  if (formatType === '石(〇〇×〇〇)') {
    sizeInfoField.placeholder = '例: 101010 (1.0mm×1.0mm)';
  } else if (formatType === 'バーツ(〇〇〇mm)') {
    sizeInfoField.placeholder = '例: 010 (10mm)';
  } else if (formatType === '1/〇〇〇形式') {
    sizeInfoField.placeholder = '例: 100 (1/100)';
  } else if (formatType === '特殊') {
    sizeInfoField.placeholder = '自由に入力してください';
  } else {
    sizeInfoField.placeholder = 'サイズ情報を入力';
  }
}

// Select2を初期化する関数
function initializeSelect2() {
  console.log("Select2の初期化を開始します");
  $('.select2-with-tags').each(function() {
    console.log("Select2要素を初期化します:", this);
    initializeSelect2ForElement(this);
  });
}

function initializeSelect2ForElement(element) {
  try {
    console.log("要素にSelect2を適用します:", element);
    $(element).select2({
      theme: 'classic',
      width: '100%',
      tags: true,
      createTag: function(params) {
        return {
          id: params.term,
          text: params.term,
          newTag: true
        };
      }
    });
    console.log("Select2の初期化が成功しました");
  } catch (error) {
    console.error("Select2の初期化中にエラーが発生しました:", error);
  }
}
