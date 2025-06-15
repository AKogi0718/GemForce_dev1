// This file is automatically compiled by Webpack
// This is a manifest file that'll be compiled into application.js

console.log('Hello from packs/application.js')

// jQueryのインポート
import 'jquery'

// Cocoonのインポート
import '@nathanvda/cocoon'

// Turboリンクスの中断設定（Cocoonとの互換性のため）
document.addEventListener("turbo:before-cache", function() {
  console.log("Turboでキャッシュする前に実行されます");
  // 特定の要素を消去または初期化
});
