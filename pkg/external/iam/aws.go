package iam

import (
	"context"
	"strings"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
	"github.com/pkg/errors"
)

func VerifyAWS(ctx context.Context, bucketName, address string, secure bool) error {
	// Initialize minio client object.
	client, err := minio.New(address, &minio.Options{
		Creds:  credentials.NewIAM(""),
		Secure: secure,
		Region: parseRegionByAddr(address),
	})
	if err != nil {
		return errors.Wrap(err, "init minio client failed")
	}
	_, err = client.BucketExists(ctx, bucketName)
	return errors.Wrapf(err, "access aws bucket[%s] failed", bucketName)
}

func parseRegionByAddr(address string) string {
	// address format: s3.us-west-1.amazonaws.com:443
	// region: us-west-1
	splited := strings.Split(address, ".")
	if len(splited) < 4 {
		return ""
	}
	return splited[1]
}
