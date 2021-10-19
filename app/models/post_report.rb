class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    words_array = post.content.split.map { |word| word.gsub(/\W/, '') }
    PostReport.new(
      # word_count
      words_array.count,
      # word_histogram
      words_array.map(&:downcase)
      .group_by { |word| word }
      .transform_values(&:size)
    )
  end
end
