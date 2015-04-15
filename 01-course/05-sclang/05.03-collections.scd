/* ============================================================ */
/* Collections                                                  */
/* ============================================================ */

// Array: fixed size
// -----------------
a = Array(4); // max size
a.add(1);

// array of nils
a = Array.newClear(4);

// shorthand
nil!4;


// Array literal
a = [1, 2, 3, 4];

a.add(10);
a.postln; // huh?

// add returns a new array
a = a.add(10);


// at / put
// --------

// zero indexed
a = ["one", "two", "three", "four"];
a[0];
a.at(0);
a@0;

a[3] = "new four";
a.put(3, "newer four");







// List: expanding
// ---------------
l = List[];
l.add(1);


// Set: unique items, unordered
// -----------------
x = Set[1, 2, 3, 4, 1];

// sort as array
x.asSortedList;
x.asArray.sort;



// Dictionary: mapping
// -------------------
// Matching on equality (==) not identity (===)

d = Dictionary();
// add
d["name"] = "Arthur";
d.add("age" -> 28);
// retrieve
d["name"].postln;

d[4] = "four";
d[2.0 + 2.0];


// Identity Dictionary
// -------------------
// Based on identity (===)

i = IdentityDictionary[];
i[\name] = "Arthur";
i[\name].postln;

i[4] = "four";
i[2.0 + 2.0]; // nil








// Collection operators
// --------------------

[1, 2, 3, 4] +  2;
[1, 2, 3, 4] -  2;
[1, 2, 3, 4] *  2;
[1, 2, 3, 4] /  2;
[1, 2, 3, 4] ** 2;

[1, 2, 3, 4] + [5, 6, 7, 8];
[1, 2, 3, 4] ++ [5, 6, 7, 8];

[[1, 2, 3, 4], [5, 6, 7, 8], [[10, 20, 30, 40], [50, 60, 70, 80]]].flatten;
[[1, 2, 3, 4], [5, 6, 7, 8], [[10, 20, 30, 40], [50, 60, 70, 80]]].flat;


// Collection Iteration
// --------------------------

[1, 2, 3, 4].do {|item, i| item.postln; };          // iterate over
[1, 2, 3, 4].collect {|item, i| item * 10; };       // transform
[1, 2, 3, 4].select {|item, i| item.even; };        // keep some
[1, 2, 3, 4].reject {|item, i| item < 3; };         // reject some
[1, 2, 3, 4].detect {|item, i| item > 2; };         // find first
[1, 2, 3, 4].any {|item, i| item > 10; };           // check if any pass test
[1, 2, 3, 4].every {|item, i| item < 10; };         // check if all pass test


// using iteration to load aiffs in a directory
~aiffs = (Platform.resourceDir +/+ "sounds/*").pathMatch.select {|path, i|
    path.contains(".aiff");
}.collect {|path, i|
    Buffer.read(s, path);
};
