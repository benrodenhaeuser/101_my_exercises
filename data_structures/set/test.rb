expected_result = <<HEREDOC
This would contain specially formatted text.

That might span many lines
 HEREDOC

expected_result_2 = <<-INDENTED_HEREDOC
This would contain specially formatted text.

That might span many lines
  INDENTED_HEREDOC

puts expected_result == expected_result_2
