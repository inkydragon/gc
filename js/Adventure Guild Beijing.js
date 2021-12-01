function talkingToTaskPublisher(){
  return "woclass"
}
//---------Task-1----------------
function add(a, b){
  return a+b
}
//---------Task-2----------------
function primeProduct(a, b){
  return mPF(a)*mPF(b)
}
function mPF(n) {
    var pf = 1; 
    for (var i = 2; n > 1; ++i) {
        if (n % i == 0) {
            n /= i;
            pf = i;
            while (n % i == 0) {
                n /= i;
            }
        }
    }
    return pf;
}
//---------Task-3----------------
function distanceOfPoints(a, b, c, d){
    var arr=new Array(a, b, c, d);
    arr.sort();
    return Math.sqrt((arr[3]-arr[0])^2+(arr[2]-arr[1])^2).toFixed(6);
}
