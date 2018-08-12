### **ITEM 12: ALWAYS OVERRIDE** `**TOSTRING**`

While `Object` provides an implementation of the `toString` method, the string that it returns is generally not what the user of your class wants to see. It consists of the class name followed by an “at” sign (`@`) and the unsigned hexadecimal representation of the hash code, for example, `PhoneNumber@163b91`. The general contract for `toString` says that the returned string should be “a concise but informative representation that is easy for a person to read.” While it could be argued that `PhoneNumber@163b91` is concise and easy to read, it isn’t very informative when compared to `707-867-5309`. The `toString` contract goes on to say, “It is recommended that all subclasses override this method.” Good advice, indeed!

While it isn’t as critical as obeying the `equals` and `hashCode` contracts ([Items 10](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev10) and [11](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev11)), **providing a good** `**toString**` **implementation makes your class much more pleasant to use and makes systems using the class easier to debug**. The `toString` method is automatically invoked when an object is passed to `println`, `printf`, the string concatenation operator, or `assert`, or is printed by a debugger. Even if you never call `toString` on an object, others may. For example, a component that has a reference to your object may include the string representation of the object in a logged error message. If you fail to override `toString`, the message may be all but useless.

If you’ve provided a good `toString` method for `PhoneNumber`, generating a useful diagnostic message is as easy as this:

[Click here to view code image](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3_images.xhtml#pch3ex26a)

System.out.println("Failed to connect to " + phoneNumber);

Programmers will generate diagnostic messages in this fashion whether or not you override `toString`, but the messages won’t be useful unless you do. The benefits of providing a good `toString` method extend beyond instances of the class to objects containing references to these instances, especially collections. Which would you rather see when printing a map, `{Jenny=PhoneNumber@163b91}` or `{Jenny=707-867-5309}`?

**When practical, the** `**toString**` **method should return** **\*all*** **of the interesting information contained in the object**, as shown in the phone number example. It is impractical if the object is large or if it contains state that is not conducive to string representation. Under these circumstances, `toString` should return a summary such as `Manhattan residential phone directory (1487536 listings)` or `Thread[main,5,main]`. Ideally, the string should be self-explanatory. (The `Thread` example flunks this test.) A particularly annoying penalty for failing to include all of an object’s interesting information in its string representation is test failure reports that look like this:

[Click here to view code image](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3_images.xhtml#pch3ex27a)

Assertion failure: expected {abc, 123}, but was {abc, 123}.

One important decision you’ll have to make when implementing a `toString` method is whether to specify the format of the return value in the documentation. It is recommended that you do this for *value classes*, such as phone number or matrix. The advantage of specifying the format is that it serves as a standard, unambiguous, human-readable representation of the object. This representation can be used for input and output and in persistent human-readable data objects, such as CSV files. If you specify the format, it’s usually a good idea to provide a matching static factory or constructor so programmers can easily translate back and forth between the object and its string representation. This approach is taken by many value classes in the Java platform libraries, including `BigInteger`, `BigDecimal`, and most of the boxed primitive classes.

The disadvantage of specifying the format of the `toString` return value is that once you’ve specified it, you’re stuck with it for life, assuming your class is widely used. Programmers will write code to parse the representation, to generate it, and to embed it into persistent data. If you change the representation in a future release, you’ll break their code and data, and they will yowl. By choosing not to specify a format, you preserve the flexibility to add information or improve the format in a subsequent release.

**Whether or not you decide to specify the format, you should clearly document your intentions.** If you specify the format, you should do so precisely. For example, here’s a `toString`method to go with the `PhoneNumber` class in [Item 11](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev11):

[Click here to view code image](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3_images.xhtml#pch3ex28a)

/**
  * Returns the string representation of this phone number.
  * The string consists of twelve characters whose format is
  * "XXX-YYY-ZZZZ", where XXX is the area code, YYY is the
  * prefix, and ZZZZ is the line number. Each of the capital
  * letters represents a single decimal digit.
    *
  * If any of the three parts of this phone number is too small
  * to fill up its field, the field is padded with leading zeros.
  * For example, if the value of the line number is 123, the last
  * four characters of the string representation will be "0123".
    */
 @Override public String toString() {
     return String.format("%03d-%03d-%04d",
             areaCode, prefix, lineNum);
 }

If you decide not to specify a format, the documentation comment should read something like this:

[Click here to view code image](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3_images.xhtml#pch3ex29a)

/**
  * Returns a brief description of this potion. The exact details
  * of the representation are unspecified and subject to change,
  * but the following may be regarded as typical:
    *
  * "[Potion #9: type=love, smell=turpentine, look=india ink]"
    */
 @Override public String toString() { ... }

After reading this comment, programmers who produce code or persistent data that depends on the details of the format will have no one but themselves to blame when the format is changed.

Whether or not you specify the format, **provide programmatic access to the information contained in the value returned by** `**toString**`**.** For example, the `PhoneNumber` class should contain accessors for the area code, prefix, and line number. If you fail to do this, you *force*programmers who need this information to parse the string. Besides reducing performance and making unnecessary work for programmers, this process is error-prone and results in fragile systems that break if you change the format. By failing to provide accessors, you turn the string format into a de facto API, even if you’ve specified that it’s subject to change.

It makes no sense to write a `toString` method in a static utility class ([Item 4](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch2.xhtml#lev4)). Nor should you write a `toString` method in most enum types ([Item 34](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch6.xhtml#lev34)) because Java provides a perfectly good one for you. You should, however, write a `toString` method in any abstract class whose subclasses share a common string representation. For example, the `toString` methods on most collection implementations are inherited from the abstract collection classes.

Google’s open source AutoValue facility, discussed in [Item 10](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev10), will generate a `toString` method for you, as will most IDEs. These methods are great for telling you the contents of each field but aren’t specialized to the *meaning* of the class. So, for example, it would be inappropriate to use an automatically generated `toString` method for our `PhoneNumber` class (as phone numbers have a standard string representation), but it would be perfectly acceptable for our `Potion` class. That said, an automatically generated `toString` method is far preferable to the one inherited from `Object`, which tells you *nothing* about an object’s value.

To recap, override `Object`’s `toString` implementation in every instantiable class you write, unless a superclass has already done so. It makes classes much more pleasant to use and aids in debugging. The `toString` method should return a concise, useful description of the object, in an aesthetically pleasing format.