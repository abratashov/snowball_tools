# frozen_string_literal: true

require 'yaml'

$lang = 'uk'
$snowball_path = ARGV.first
$snowball_cmd = "#{$snowball_path}/stemwords -l #{$lang}"
$all_tests = []
$errors = {}

def incorrect_stem_msg(result_stem, word, stem)
  "Word:      #{word}\n" \
    "should be: #{stem}\n" \
    "but it is: #{result_stem}\n"
end

[
  [IO.read('./algorithms/ukrainian/tests/00_short_word.txt').split, '00_short_word'],
  [IO.read('./algorithms/ukrainian/tests/01_perfective_gerund.txt').split, '01_perfective_gerund'],
  [IO.read('./algorithms/ukrainian/tests/02_reflexive.txt').split, '02_reflexive'],
  [IO.read('./algorithms/ukrainian/tests/03_adjective.txt').split, '03_adjective'],
  [IO.read('./algorithms/ukrainian/tests/04_adjectival.txt').split, '04_adjectival'],
  [IO.read('./algorithms/ukrainian/tests/05_verb.txt').split, '05_verb'],
  [IO.read('./algorithms/ukrainian/tests/06_noun.txt').split, '06_noun'],
  [IO.read('./algorithms/ukrainian/tests/07_remove_last_letter.txt').split, '07_remove_last_letter'],
  [IO.read('./algorithms/ukrainian/tests/08_derivational.txt').split, '08_derivational'],
  [IO.read('./algorithms/ukrainian/tests/09_tidy_up.txt').split, '09_tidy_up'],
  [IO.read('./algorithms/ukrainian/tests/10_other.txt').split, '10_other'],
  [IO.read('./algorithms/ukrainian/tests/12_approve.txt').split, '03_test_victory']
].each do |test_words, set_name|
  test_words.each do |test_word|
    stem, ending = test_word.to_s.split('|')
    word = [stem, ending&.delete('.')].join('')
    $all_tests << word
    result_stem = `echo "#{word}" | #{$snowball_cmd}`.strip
    $errors[set_name] ||= []
    $errors[set_name] << incorrect_stem_msg(result_stem, word, stem) if result_stem != stem
  end
end

[
  [YAML.load_file('./algorithms/ukrainian/tests/11_replacement.yml'), '11_exceptions']
].each do |words_set, set_name|
  words_set.each do |word, test_case|
    stem, = test_case.to_s.split('|')
    $all_tests << word
    result_stem = `echo "#{word}" | #{$snowball_cmd}`.strip
    $errors[set_name] ||= []
    $errors[set_name] << incorrect_stem_msg(result_stem, word, stem) if result_stem != stem
  end
end

if $errors.values.all?(&:empty?)
  puts("#{$all_tests.count} test(s) passed successfully!")
else
  $errors.each do |set_name, errs|
    next if errs.empty?

    puts "\n=== #{set_name}:\n\n"
    puts(errs.join("\n"))
  end
end
