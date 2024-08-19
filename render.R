

library(quarto)
library(tidyverse)
library(rmarkdown)
library(janitor)

data <- clean_names(iris)

species <- data %>% 
  pull(species) %>% 
  as.character() %>% 
  unique()

report_params <- tibble(
  species = species,
  image_paths = c("media/setosa.png", "media/versicolor.png", "media/virginica.png"),
  descriptions = ""
)

report_params <- report_params %>% 
  mutate(descriptions = case_when(species == "setosa" ~ 
                                    "Iris setosa has a deep violet blue flower. The sepals are deeply-veined dark purple with a yellow-white
                                    signal. The petals are very reduced in size, not exceeding the base of the sepals. Beachhead iris flowers in
                                    late spring, on a one flowered inflorescence. The leaves are stiff, narrow and green, with a purplish tinged
                                    base. The leaves are up to 12 inches high. The leaves arise from shallowly rooted, large, branching rhizomes
                                    forming clumps.[@irisset]",
                                  species == "versicolor" ~
                                    "A graceful, sword-leaved plant similar to the garden iris, with showy, down-curved, violet, boldly veined 
                                  sepals. Several violet-blue flowers with attractively veined and yellow-based sepals are on a sturdy stalk among 
                                  tall sword-like leaves that rise from a basal cluster. Flowers may be any shade of purple, but are always 
                                  decorated with yellow on the falls. Grows 2-3 ft. tall. [@ladybirdjohnsonwildflowercenter]",
                                  species == "virginica" ~
                                    "Southern blue flag iris is a lovely, delicate iris native to the United States and Canada, from the east 
                                  coast to the middle states as far west as Texas. The genus name Iris is named after the Greek Goddess of rainbows 
                                  and the species name refers to the state of Virginia where it is found.  The common name, flag, comes from an old 
                                  English word (flagge) for reeds and refers to its natural preference to wetlands.[@ncstate]"))


reports <- tibble(
  input = "t4.qmd",
  output_file = str_c("reports/", species, ".pdf"),
)

reports <- reports %>% 
  bind_cols(report_params) %>% 
  mutate(params = pmap(list(species, image_paths, descriptions), ~ list(species = ..1, image_paths = ..2, descriptions = ..3))) %>% 
  select(input, output_file, params)

reports %>% 
  pwalk(render)
