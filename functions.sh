# Use `docker-cleanup --dry-run` to see what would be deleted.

function docker-cleanup {
  DANGLING=$(docker images -q -f "dangling=true")
  EXITED=$(docker ps -q -f "status=exited")

  if [ "$1" == "--dry-run" ]; then
    echo "==> Would stop containers:"
    echo $EXITED
    echo "==> And images:"
    echo $DANGLING
  else
    if [ -n "$EXITED" ]; then
      docker rm $EXITED
    else
      echo "No containers to remove."
    fi
    if [ -n "$DANGLING" ]; then
      docker rmi $DANGLING
    else
      echo "No images to remove."
    fi
  fi
}
