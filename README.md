<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://stackedit.io/style.css" />
</head>

<body class="stackedit">
  <div class="stackedit__html"><h1 id="klear">Klear</h1>
<p>This is a partial clone of the excellent <a href="https://apps.apple.com/us/app/clear-todos/id493136154" title="Clear Todos">Clear Todos</a> app by <a href="https://realmacsoftware.com" title="Real Mac Software">Real Mac Software</a>, written in Swift</p>
<p>I’ve created this app, as a way to get familiar with the Swift language and especially gesture recognizers, delegates and animation. Since this was done for educational purposes I’ve:</p>
<ul>
<li>not used third party libraries</li>
<li>tried to imitate the look and feel of the original app, as possible as I could.</li>
</ul>
<h2 id="implemented-features">Implemented Features</h2>
<h4 id="drag-to-add-new-item">drag to add new item</h4>
<p>Core Animation 3D tranforms is used for the perspective<br>
<img src="https://media.giphy.com/media/TjFPqPWuSSX1DmY4eq/giphy.gif" alt=""></p>
<hr>
<h4 id="drag--drop-to-re-order">drag &amp; drop to re-order</h4>
<p>The drag and drop functionality is  “custom”: I am not using Apple’s drag/drop interaction APIs, due to no control of how the draggable item is presented.</p>
<p><img src="https://media.giphy.com/media/U3DWk491ADhE3KPOn2/giphy.gif" alt="">  <img src="https://media.giphy.com/media/J2CbP2cefk2YS0vOoR/giphy.gif" alt=""></p>
<hr>
<h4 id="swipe-right-to-set-to-donenot-done">swipe right to set to done/not-done</h4>
<p>panning and the done/cancelled animation is handled by the actual cell view. View controller is set as delegate and it is informed when a panning threshold is passed (to change the background color accordingly) and when the action completes and handles the rest of the other actions (animate the cell to the its new position, update the model etc)</p>
<p><img src="https://media.giphy.com/media/W4owiFRurHn4Z0TW1x/giphy.gif" alt=""></p>
<hr>
<h4 id="swipe-left-to-delete">swipe left to delete</h4>
<p>panning and the done/cancelled animation is handled by the actual cell view. View controller is set as delegate and it is informed when the action  completes.</p>
<p><img src="https://media.giphy.com/media/hu1qJycMizGPBkK0jH/giphy.gif" alt=""></p>
<h4 id="touch-cell-to-edit-it">touch cell to edit it</h4>
<hr>
<p>the cell view handles the touches as follows:</p>
<p><a href="https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG5nZXN0dXJlIHJlY29nbml6ZXIgLT4-IHRleHRGaWVsZDogYmVjb21lRmlyc3RSZXNwb25kZXJcbnRleHRGaWVsZC0-PiB0ZXh0RmllbGQgZGVsZWdhdGUgKG9uIHZpZXcpOiB0ZXh0RmllbGREaWRCZWdpbkVkaXRpbmcgXG50ZXh0RmllbGQgZGVsZWdhdGUgKG9uIHZpZXcpIC0-PiBWQzp0b2RvQ2VsbFdpbGxNb2RpZnlcblx0XHRcdFx0XHQiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ"><img src="https://mermaid.ink/img/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG5nZXN0dXJlIHJlY29nbml6ZXIgLT4-IHRleHRGaWVsZDogYmVjb21lRmlyc3RSZXNwb25kZXJcbnRleHRGaWVsZC0-PiB0ZXh0RmllbGQgZGVsZWdhdGUgKG9uIHZpZXcpOiB0ZXh0RmllbGREaWRCZWdpbkVkaXRpbmcgXG50ZXh0RmllbGQgZGVsZWdhdGUgKG9uIHZpZXcpIC0-PiBWQzp0b2RvQ2VsbFdpbGxNb2RpZnlcblx0XHRcdFx0XHQiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ" alt=""></a></p>
<p>VC will scroll the table so that the cell will go to the top and will shade all other cells<br>
Action completes when user either:</p>
<ul>
<li>presses return on keyboard, or</li>
<li>taps outside the cell</li>
</ul>
<p><a href="https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG5nZXN0dXJlIHJlY29nbml6ZXIgKG9uIFZDKS0tPj4gdGV4dEZpZWxkOnZpZXcuZW5kRWRpdGluZ1xuXG50ZXh0RmllbGQtPj4gdGV4dEZpZWxkIGRlbGVnYXRlIChvbiB2aWV3KTogdGV4dEZpZWxkdGV4dEZpZWxkRGlkRW5kRWRpdGluZ1xudGV4dEZpZWxkIGRlbGVnYXRlIChvbiB2aWV3KSAtPj5WQzp0b2RvQ2VsbFdhc01vZGlmaWVkXG5cdFx0XHRcdFx0IiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0"><img src="https://mermaid.ink/img/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG5nZXN0dXJlIHJlY29nbml6ZXIgKG9uIFZDKS0tPj4gdGV4dEZpZWxkOnZpZXcuZW5kRWRpdGluZ1xuXG50ZXh0RmllbGQtPj4gdGV4dEZpZWxkIGRlbGVnYXRlIChvbiB2aWV3KTogdGV4dEZpZWxkdGV4dEZpZWxkRGlkRW5kRWRpdGluZ1xudGV4dEZpZWxkIGRlbGVnYXRlIChvbiB2aWV3KSAtPj5WQzp0b2RvQ2VsbFdhc01vZGlmaWVkXG5cdFx0XHRcdFx0IiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0" alt=""></a></p>
<p>ViewController  (once notified) will handle scrolling to the initial position and unshading of the other cells</p>
<p><img src="https://media.giphy.com/media/hrv6Cn0OJgzBWDuHMB/giphy.gif" alt=""> <img src="https://media.giphy.com/media/RlrfSE0jJuWQHjORns/giphy.gif" alt=""></p>
<hr>
<h4 id="dynamic-gradient">dynamic gradient</h4>
<p>An array of 7 UIColors (from red to yellow) defines the background color of each cell (first cell gets first color from the array etc.)<br>
If the table has more cells then the color is calculated by interpolation from the start to the end color (<a href="https://stackoverflow.com/a/58107103">https://stackoverflow.com/a/58107103</a>)</p>
<p><img src="https://media.giphy.com/media/QYXiyo3xbozEhjQram/giphy.gif" alt=""></p>
</div>
</body>

</html>
