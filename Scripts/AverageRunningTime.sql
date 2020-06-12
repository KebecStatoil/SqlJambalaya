DECLARE @DestinationDataset AS NVARCHAR(150) = '%IWIT%'
SELECT
  [DestinationDataset],
  AVG(
    DATEDIFF (second, [ExtractionTimeUTC], [CompletedTimeUTC])
  ) AS AverageLoadingTimeInSeconds
FROM
  [Common].[DataTransferLog]
  /**** Enter any filter here ****/
WHERE
  [DestinationDataset] Like @DestinationDataset
GROUP BY
  [DestinationDataset]
ORDER BY
  AverageLoadingTimeInSeconds Desc