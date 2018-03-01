# NumRu (NumPy in Ruby)

NumRu is adoption of NumPy in Ruby. The aim is not just to port NumPy to Ruby but to adopt it to Ruby syntax and ease.

## Installation

1. You need Python 2 for this to work. It uses `rubypython` which currently only works for Python 2 but work is underway to make it work for Python 3.

2. Install `numpy` package for Python.

3. Add this line to your application's Gemfile:

```ruby
gem 'numru'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install numru

## Usage

1. Whatever works in NumPy works here. If there's something that doesn't work let me know in the issues.
```rb
require 'numru'
nr = NumRu

> x = nr.array 0..10
=> array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10])

> x = nr.arange(27).reshape 3, 3, 3
=> array([[[ 0,  1,  2],
        [ 3,  4,  5],
        [ 6,  7,  8]],

       [[ 9, 10, 11],
        [12, 13, 14],
        [15, 16, 17]],

       [[18, 19, 20],
        [21, 22, 23],
        [24, 25, 26]]])

```
2. Keyword arguments are not supported. For that use hash instead.
```rb
> x = nr.array [1, 2, 3], dtype: :complex
=> array([1.+0.j, 2.+0.j, 3.+0.j])

> x = nr.array [1, 2, 3], dtype: nr.int32
=> array([1, 2, 3], dtype=int32)
```
3. Indexing is similar to numpy except it use Ruby Range instead of Python Slice
```rb
> x = nr.array(20.times.map { |i| i**2 }).reshape 4, 5
=> array([[  0,   1,   4,   9,  16],
       [ 25,  36,  49,  64,  81],
       [100, 121, 144, 169, 196],
       [225, 256, 289, 324, 361]])
> x[0]
=> array([[ 0,  1,  4,  9, 16]])
> x[[0, 1]]
=> array([[ 0,  1,  4,  9, 16],
       [25, 36, 49, 64, 81]])
> x[0..1]
=> array([[ 0,  1,  4,  9, 16],
       [25, 36, 49, 64, 81]])
> x[0..-1, -1]
=> array([ 16,  81, 196, 361])
> x[0..-1, -2..-1]
=> array([[  9,  16],
       [ 64,  81],
       [169, 196],
       [324, 361]])

```
4. Slicing is supported too but it has to be wrapped inside quotes
```rb
> x = nr.arange(25).reshape(5, 5).T
=> array([[ 0,  5, 10, 15, 20],
       [ 1,  6, 11, 16, 21],
       [ 2,  7, 12, 17, 22],
       [ 3,  8, 13, 18, 23],
       [ 4,  9, 14, 19, 24]])
> x['::', '::-1']
=> array([[20, 15, 10,  5,  0],
       [21, 16, 11,  6,  1],
       [22, 17, 12,  7,  2],
       [23, 18, 13,  8,  3],
       [24, 19, 14,  9,  4]])
> x[':3', ':3']
=> array([[ 0,  5, 10],
       [ 1,  6, 11],
       [ 2,  7, 12]])

```

## In development

The motive is not just to build a wrapper for NumPy but to adapt it to Ruby.

Rough plan

1. Provide all numpy functionality
2. Provide `map`, `each`, etc.
3. TODO: Think and discuss how to rubify the API

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lokeshh/numru. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Numru project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/numru/blob/master/CODE_OF_CONDUCT.md).
