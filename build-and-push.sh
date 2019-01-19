# Build
hugo -F

# Push
aws s3 cp public s3://josh.sansomsherwill.com/ --recursive