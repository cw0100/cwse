var ffi = require("ffi");

function TEXT(text){
	return new Buffer(text, "ucs2").toString("binary");
}

var user32 = new ffi.Library("user32", {
	"MessageBoxW":[
		"int32", ["int32", "string", "string", "int32"]
	]
	}
	);

var OK_or_Cancel = user32.MessageBoxW(
		0, TEXT("I am Node.js!"), TEXT("Hello, World!"), 1
		);

console.log(OK_or_Cancel);
