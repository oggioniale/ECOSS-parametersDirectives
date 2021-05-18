library('dplyr')
#creating simulated data
data <- data.frame(
  c('Solar Panels', 'Fossil Fuels', 'Wind Turbines'), 
  c(15,80,5), 
  c(40, 40, 20)
)
colnames(data) <- c('Energy Source', 'United States', 'European Union')

#creating pie chart nested within donut chart
plot3 <- plotly::plot_ly(data) %>%
  plotly::add_pie(
    labels = ~`Energy Source`, 
    values = ~`United States`, 
    type = 'pie', 
    marker = list(line = list(width = 2)),
    hole = 0.7, 
    sort = F
  ) %>%
  plotly::add_pie(
    data, 
    labels = ~`Energy Source`, 
    values = ~`European Union`, 
    domain = list(
      x = c(0.15, 0.85),
      y = c(0.15, 0.85)
    ),
    hole = 0.6,
    sort = F
  )

#printing plot
plot3

dataOuterCircle <- data.frame(
  c(
    'label1', 'label2', 'label3', 'label4', 
    'label5', 'label6', 'label7', 'label8', 
    'label9', 'label10', 'label11', 'label12',
    'label13', 'label14', 'label15', 'label16', 'label17'
  ),
  c(
    # 100 / sum of all elements of each entities, replicate for number of total elements in the different entities.
    # E.g. 2 target species, 0 habitat, 12 ECOSS parameters and 3 Parameters declared
    replicate(sum(2,12,3), 100/sum(2,12,3))
  ) # outer circle values
)
colnames(dataOuterCircle) <- c('entityLabel', 'value')

dataInnerCircle <- data.frame(
  c('target species', 'habitat', 'ECOSS parameters recomendent', 'Parameters declared by site'), # entities
  c(
    (100/sum(2,12,3)) * 2,
    (100/sum(2,12,3)) * 0,
    (100/sum(2,12,3)) * 12,
    (100/sum(2,12,3)) * 3
  ) # inner circle values
)
colnames(dataInnerCircle) <- c('entityType', 'value')


#creating pie chart nested within donut chart
plot <- plotly::plot_ly(dataOuterCircle) %>%
  plotly::add_pie(
    labels = ~`entityLabel`, 
    values = ~`value`, 
    type = 'pie', 
    marker = list(line = list(width = 2)),
    hole = 0.7, 
    sort = F
  ) %>%
  plotly::add_pie(
    dataInnerCircle, 
    labels = ~entityType, 
    values = ~`value`, 
    domain = list(
      x = c(0.15, 0.85),
      y = c(0.15, 0.85)
    ),
    hole = 0.6,
    sort = F
  )

plot
