# JSON parser - ruby

This is only an attempt at learning ruby, by building a JSON parser.
much of this has been guided by the [JSON IETF spec](https://datatracker.ietf.org/doc/html/rfc7159)

#### Note
This isn't meant to be used for anything other than learning purposes, as it wasn't built with optimisations, good error reporting or even completeness in mind, while it is spec complete (mostly), it certainly isn't a replacement for the `parse` export of the Ruby `JSON` module.


```
ruby parser.rb
```

### Tests
Tests are simple assertions of the return values of the built-in JSON parser vs this parser.
```
ruby parser_test.rb
```

## Contributing
As this is only a fun project, kindly concern only with bug fixes, as I do not intend to do any more development work on this.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)