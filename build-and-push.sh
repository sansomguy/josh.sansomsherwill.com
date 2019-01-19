# Build
hugo -F

# Push
aws s3 sync public s3://josh.sansomsherwill.com