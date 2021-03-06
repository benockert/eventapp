// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.

// import bootstrap styling
import "bootstrap"
import "bootstrap-datepicker"
// for querying datepicker
import $ from 'jquery'

// import custom css
import "../css/app.scss"
import "../css/datepicker.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

// gets today's date
var date = new Date();
var today = new Date(date.getFullYear(), date.getMonth(), date.getDate());

// sets up the datepicker for elements with id 'datepicker'; returns the selected date in
// month/day/year format; highlights today's date, only allows dates from today on, and
// closes the popup when a date is selected
$('#datepicker').datepicker({
  format: "mm/dd/yyyy",
  todayHighlight: true,
  startDate: today,
  autoclose: true
});
